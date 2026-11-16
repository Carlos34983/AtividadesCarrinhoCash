//compra segura


const LOT_ID = 101;

function comprarIngresso(customerId, idempotencyKey) {
    const pedidoExistente = db.orders.findOne({
        idempotency_key: idempotencyKey
    });

    if (pedidoExistente) {
        return {
            resultado: "SOLICITACAO_JA_PROCESSADA",
            pedido_id: pedidoExistente._id
        };
    }

    const lote = db.event_sector_prices.findOneAndUpdate(
        {
            _id: LOT_ID,
            available: { $gt: 0 }
        },
        {
            $inc: { available: -1 }
        },
        {
            returnDocument: "after"
        }
    );

    if (!lote) {
        return { resultado: "INGRESSOS_ESGOTADOS" };
    }

   const orderId = db.counters.findOneAndUpdate(
    {_id: "orders"},
    {$inc: {seq: 1}},
    {returnDocument: "after"}
).seq;

const paymentId = db.counters.findOneAndUpdate(
    {_id: "payments"},
    {$inc: {seq: 1}},
    {returnDocument: "after"}
).seq;

const ticketId = db.counters.findOneAndUpdate(
    {_id: "tickets"},
    {$inc: {seq: 1}},
    {returnDocument: "after"}
).seq;

    try {
        db.orders.insertOne({
            _id: orderId,
            idempotency_key: idempotencyKey,
            customer_id: customerId,
            event_id: lote.event_id,
            status: "paid",
            items: [{
                sector_id: LOT_ID,
                sector_name: lote.sector_name,
                quantity: 1,
                unit_price: lote.price,
                subtotal: lote.price
            }],
            total: lote.price,
            created_at: new Date()
        });

        db.payments.insertOne({
            _id: paymentId,
            order_id: orderId,
            idempotency_key: idempotencyKey,
            amount: lote.price,
            status: "approved",
            provider: "mock",
            created_at: new Date()
        });

        db.tickets.insertOne({
            _id: ticketId,
            order_id: orderId,
            customer_id: customerId,
            event_id: lote.event_id,
            sector_id: LOT_ID,
            ticket_code: "TK-TESTE-" + orderId,
            status: "valid",
            created_at: new Date()
        });

        return {
            resultado: "COMPRA_CONFIRMADA",
            pedido_id: orderId,
            ingresso_id: ticketId
        };

    } catch (erro) {
        db.tickets.deleteOne({ _id: ticketId });
        db.payments.deleteOne({ _id: paymentId });
        db.orders.deleteOne({ _id: orderId });

        db.event_sector_prices.updateOne(
            { _id: LOT_ID },
            { $inc: { available: 1 } }
        );

        if (erro.code === 11000) {
            return { resultado: "SOLICITACAO_JA_PROCESSADA" };
        }

        throw erro;
    }
}
