CALL process_order(1);

DELIMITER //

CREATE OR REPLACE PROCEDURE process_order(IN p_customer_id BIGINT)
BEGIN
    DECLARE v_cart_id BIGINT;
    DECLARE v_order_id BIGINT;
    DECLARE v_total DECIMAL(10, 2) DEFAULT 0;
    DECLARE v_product_id BIGINT;
    DECLARE v_quantity BIGINT;
    DECLARE v_product_name VARCHAR(255);
    DECLARE v_product_price DECIMAL(10, 2);
    DECLARE v_done BOOLEAN DEFAULT FALSE;
    DECLARE v_cart_count INT DEFAULT 0;

    DECLARE cart_items_cursor CURSOR FOR
        SELECT
            ci.product_id,
            ci.quantity,
            p.name,
            p.price
        FROM cart_items ci
        JOIN products p ON p.id = ci.product_id
        WHERE ci.cart_id = v_cart_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_cart_count
    FROM carts
    WHERE customer_id = p_customer_id
      AND status = 'open';

    IF v_cart_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente nao possui carrinho aberto.';
    END IF;

    SELECT id
    INTO v_cart_id
    FROM carts
    WHERE customer_id = p_customer_id
      AND status = 'open'
    ORDER BY id
    LIMIT 1
    FOR UPDATE;

    INSERT INTO orders (
        customer_id,
        total,
        status,
        paid_at,
        created_at,
        updated_at
    ) VALUES (
        p_customer_id,
        0,
        'paid',
        NOW(),
        NOW(),
        NOW()
    );

    SET v_order_id = LAST_INSERT_ID();

    OPEN cart_items_cursor;

    read_items: LOOP

        FETCH cart_items_cursor
        INTO v_product_id,
             v_quantity,
             v_product_name,
             v_product_price;

        IF v_done THEN
            LEAVE read_items;
        END IF;

        IF v_quantity <= 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantidade de produto invalida.';
        END IF;

        IF (SELECT stock FROM products WHERE id = v_product_id) < v_quantity THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente para um dos produtos.';
        END IF;

        INSERT INTO order_items (
            order_id,
            product_id,
            product_name,
            product_price,
            quantity,
            created_at,
            updated_at
        ) VALUES (
            v_order_id,
            v_product_id,
            v_product_name,
            v_product_price,
            v_quantity,
            NOW(),
            NOW()
        );

        UPDATE products
        SET stock = stock - v_quantity,
            updated_at = NOW()
        WHERE id = v_product_id;

        SET v_total = v_total + (v_product_price * v_quantity);

    END LOOP;

    CLOSE cart_items_cursor;

    UPDATE orders
    SET total = v_total,
        updated_at = NOW()
    WHERE id = v_order_id;

    DELETE FROM cart_items
    WHERE cart_id = v_cart_id;

    UPDATE carts
    SET status = 'confirmed',
        updated_at = NOW()
    WHERE id = v_cart_id;

    COMMIT;
END //

DELIMITER ;