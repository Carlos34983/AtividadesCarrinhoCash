//compra vuneravel

const LOT_ID = 102;

function comprarVulneravel(numero) {
    const lote = db.event_sector_prices.findOne({_id: LOT_ID});

    if (!lote || lote.available <= 0) {
        return {
            resultado: "SEM_ESTOQUE",
            solicitacao: numero
        };
    }

    // Simula o intervalo entre a consulta e a atualiza��o.
    const inicio = Date.now();
    while (Date.now() - inicio < 1500) {}

    // ERRO INTENCIONAL: n�o verifica novamente o estoque.
    db.event_sector_prices.updateOne(
        {_id: LOT_ID},
        {$inc: {available: -1}}
    );

    return {
        resultado: "COMPRA_REALIZADA",
        solicitacao: numero,
        estoque_lido: lote.available
    };
}
