DELIMITER //

CREATE OR REPLACE PROCEDURE apply_cashback(IN p_order_id BIGINT)
BEGIN
    DECLARE v_customer_id BIGINT;
    DECLARE v_total DECIMAL(10, 2);
    DECLARE v_percentage DECIMAL(5, 2);
    DECLARE v_cashback DECIMAL(10, 2);

    START TRANSACTION;

  
    SELECT customer_id, total
    INTO v_customer_id, v_total
    FROM orders
    WHERE id = p_order_id
      AND status = 'paid'
    FOR UPDATE;

    
    IF v_total <= 100 THEN
        SET v_percentage = 2.00;
    ELSEIF v_total <= 500 THEN
        SET v_percentage = 5.00;
    ELSE
        SET v_percentage = 10.00;
    END IF;

    SET v_cashback = v_total * (v_percentage / 100);

    UPDATE customers
    SET cashback_balance = cashback_balance + v_cashback,
        updated_at = NOW()
    WHERE id = v_customer_id;

    INSERT INTO cashback_histories (
        customer_id,
        order_id,
        amount,
        percentage,
        created_at,
        updated_at
    ) VALUES (
        v_customer_id,
        p_order_id,
        v_cashback,
        v_percentage,
        NOW(),
        NOW()
    );

    COMMIT;
END //

DELIMITER ;