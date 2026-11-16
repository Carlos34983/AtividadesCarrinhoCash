/*
 * ATIVIDADE PRÁTICA — MONGODB
 * Modelagem documental e decisões arquiteturais
 *
 * Execução:
 * mongosh "mongodb://localhost:27017" atividade_mongodb.js
 *
 * ATENÇÃO:
 * O script recria as collections utilizadas nesta atividade.
 * Transações reais exigem replica set ou cluster compatível.
 */

const database = db.getSiblingDB("vendas_mongodb");

print("\n=== 1. PREPARAÇÃO DO BANCO ===");

[
  "customers",
  "products",
  "orders",
  "product_price_history",
  "reviews"
].forEach(nome => database[nome].drop());

database.createCollection("customers");
database.createCollection("products");
database.createCollection("orders");
database.createCollection("product_price_history");
database.createCollection("reviews");

// CLIENTES
database.customers.insertMany([
  { _id: 1, name: "Ana Souza", email: "ana@example.com", city: "Curitiba" },
  { _id: 2, name: "Bruno Lima", email: "bruno@example.com", city: "Ponta Grossa" },
  { _id: 3, name: "Carla Mendes", email: "carla@example.com", city: "Guarapuava" },
  { _id: 4, name: "Diego Alves", email: "diego@example.com", city: "Prudentópolis" }
]);

// PRODUTOS
database.products.insertMany([
  { _id: 101, name: "Notebook", price: 4500, stock: 20, category: "Eletrônicos" },
  { _id: 102, name: "Mouse", price: 80, stock: 100, category: "Acessórios" },
  { _id: 103, name: "Teclado", price: 180, stock: 60, category: "Acessórios" },
  { _id: 104, name: "Monitor", price: 1200, stock: 25, category: "Eletrônicos" },
  { _id: 105, name: "Headset", price: 250, stock: 40, category: "Acessórios" },
  { _id: 106, name: "Webcam", price: 320, stock: 30, category: "Acessórios" },
  { _id: 107, name: "SSD 1 TB", price: 550, stock: 35, category: "Armazenamento" },
  { _id: 108, name: "Memória RAM", price: 280, stock: 50, category: "Componentes" },
  { _id: 109, name: "Placa de vídeo", price: 2200, stock: 12, category: "Componentes" },
  { _id: 110, name: "Roteador", price: 400, stock: 18, category: "Redes" },
  { _id: 111, name: "Cabo HDMI", price: 45, stock: 150, category: "Acessórios" },
  { _id: 112, name: "Microfone", price: 600, stock: 15, category: "Acessórios" }
]);

// PEDIDOS
// Os itens são incorporados ao pedido e preservam o preço histórico.
const agora = new Date();
const diasAtras = dias =>
  new Date(agora.getTime() - dias * 24 * 60 * 60 * 1000);

database.orders.insertMany([
  {
    _id: 1001,
    customerId: 1,
    customerSnapshot: {
      name: "Ana Souza",
      email: "ana@example.com"
    },
    createdAt: diasAtras(5),
    status: "completed",
    items: [
      { productId: 101, productName: "Notebook", quantity: 1, unitPrice: 4500 },
      { productId: 102, productName: "Mouse", quantity: 2, unitPrice: 80 }
    ],
    total: 4660
  },
  {
    _id: 1002,
    customerId: 2,
    customerSnapshot: {
      name: "Bruno Lima",
      email: "bruno@example.com"
    },
    createdAt: diasAtras(12),
    status: "completed",
    items: [
      { productId: 104, productName: "Monitor", quantity: 2, unitPrice: 1200 },
      { productId: 103, productName: "Teclado", quantity: 1, unitPrice: 180 }
    ],
    total: 2580
  },
  {
    _id: 1003,
    customerId: 1,
    customerSnapshot: {
      name: "Ana Souza",
      email: "ana@example.com"
    },
    createdAt: diasAtras(25),
    status: "completed",
    items: [
      { productId: 101, productName: "Notebook", quantity: 1, unitPrice: 4500 },
      { productId: 105, productName: "Headset", quantity: 1, unitPrice: 250 }
    ],
    total: 4750
  },
  {
    _id: 1004,
    customerId: 3,
    customerSnapshot: {
      name: "Carla Mendes",
      email: "carla@example.com"
    },
    createdAt: diasAtras(45),
    status: "completed",
    items: [
      { productId: 109, productName: "Placa de vídeo", quantity: 1, unitPrice: 2200 },
      { productId: 107, productName: "SSD 1 TB", quantity: 2, unitPrice: 550 }
    ],
    total: 3300
  },
  {
    _id: 1005,
    customerId: 4,
    customerSnapshot: {
      name: "Diego Alves",
      email: "diego@example.com"
    },
    createdAt: diasAtras(110),
    status: "completed",
    items: [
      { productId: 101, productName: "Notebook", quantity: 1, unitPrice: 4300 }
    ],
    total: 4300
  },
  {
    _id: 1006,
    customerId: 2,
    customerSnapshot: {
      name: "Bruno Lima",
      email: "bruno@example.com"
    },
    createdAt: diasAtras(2),
    status: "completed",
    items: [
      { productId: 101, productName: "Notebook", quantity: 1, unitPrice: 4500 },
      { productId: 106, productName: "Webcam", quantity: 1, unitPrice: 320 }
    ],
    total: 4820
  }
]);

database.orders.createIndex({ customerId: 1, createdAt: -1 });
database.orders.createIndex({ "items.productId": 1 });
database.product_price_history.createIndex({ productId: 1, changedAt: -1 });
database.reviews.createIndex({ productId: 1, createdAt: -1 });

print("Clientes: " + database.customers.countDocuments());
print("Produtos: " + database.products.countDocuments());
print("Pedidos: " + database.orders.countDocuments());


// 2. EXEMPLO DE DOCUMENTO
print("\n=== 2. DOCUMENTO DE PEDIDO ===");
printjson(database.orders.findOne({ _id: 1001 }));


// 3. HISTÓRICO DE COMPRAS
print("\n=== 3. HISTÓRICO DE COMPRAS DO CLIENTE ANA ===");

database.orders.find(
  { customerId: 1 },
  {
    _id: 1,
    createdAt: 1,
    status: 1,
    items: 1,
    total: 1,
    customerSnapshot: 1
  }
).sort({ createdAt: -1 }).forEach(printjson);


// 4. RANKING DE PRODUTOS NOS ÚLTIMOS 90 DIAS
print("\n=== 4. TOP 10 PRODUTOS POR FATURAMENTO ===");

database.orders.aggregate([
  {
    $match: {
      createdAt: { $gte: diasAtras(90) },
      status: "completed"
    }
  },
  { $unwind: "$items" },
  {
    $group: {
      _id: "$items.productId",
      productName: { $first: "$items.productName" },
      unitsSold: { $sum: "$items.quantity" },
      revenue: {
        $sum: {
          $multiply: [
            "$items.quantity",
            "$items.unitPrice"
          ]
        }
      }
    }
  },
  { $sort: { revenue: -1 } },
  { $limit: 10 },
  {
    $project: {
      _id: 0,
      productId: "$_id",
      productName: 1,
      unitsSold: 1,
      revenue: 1
    }
  }
]).forEach(printjson);


// 5. INDICADORES POR CLIENTE
print("\n=== 5. INDICADORES POR CLIENTE ===");

database.orders.aggregate([
  { $match: { status: "completed" } },
  {
    $addFields: {
      itemCount: { $sum: "$items.quantity" }
    }
  },
  {
    $group: {
      _id: "$customerId",
      orderCount: { $sum: 1 },
      productsPurchased: { $sum: "$itemCount" },
      totalSpent: { $sum: "$total" }
    }
  },
  {
    $addFields: {
      averageOrderValue: {
        $round: [
          { $divide: ["$totalSpent", "$orderCount"] },
          2
        ]
      }
    }
  },
  {
    $lookup: {
      from: "customers",
      localField: "_id",
      foreignField: "_id",
      as: "customer"
    }
  },
  { $unwind: "$customer" },
  {
    $project: {
      _id: 0,
      customerId: "$_id",
      customerName: "$customer.name",
      orderCount: 1,
      productsPurchased: 1,
      totalSpent: 1,
      averageOrderValue: 1
    }
  },
  { $sort: { totalSpent: -1 } }
]).forEach(printjson);


// 6. CLIENTES QUE COMPRARAM DETERMINADO PRODUTO
print("\n=== 6. QUEM COMPROU O NOTEBOOK? ===");

database.orders.aggregate([
  { $match: { "items.productId": 101, status: "completed" } },
  { $unwind: "$items" },
  { $match: { "items.productId": 101 } },
  {
    $group: {
      _id: "$customerId",
      orders: {
        $addToSet: "$_id"
      },
      quantityBought: {
        $sum: "$items.quantity"
      }
    }
  },
  {
    $lookup: {
      from: "customers",
      localField: "_id",
      foreignField: "_id",
      as: "customer"
    }
  },
  { $unwind: "$customer" },
  {
    $project: {
      _id: 0,
      customerId: "$_id",
      customerName: "$customer.name",
      orders: 1,
      quantityBought: 1
    }
  }
]).forEach(printjson);


// 7. HISTÓRICO DE PREÇO E AUDITORIA
print("\n=== 7. ALTERAÇÃO DE PREÇO E AUDITORIA ===");

const pedidoAntigo = database.orders.findOne({ _id: 1001 });

print("Preço no pedido antes da alteração:");
printjson(pedidoAntigo.items[0].unitPrice);

const produtoAntes = database.products.findOne({ _id: 101 });
const novoPreco = 5200;

database.product_price_history.insertOne({
  productId: produtoAntes._id,
  productName: produtoAntes.name,
  oldPrice: produtoAntes.price,
  newPrice: novoPreco,
  changedAt: new Date(),
  source: "script_atividade"
});

database.products.updateOne(
  { _id: 101 },
  { $set: { price: novoPreco } }
);

print("Preço atual do produto:");
printjson(
  database.products.findOne(
    { _id: 101 },
    { name: 1, price: 1 }
  )
);

print("Preço preservado no pedido antigo:");
printjson(
  database.orders.findOne(
    { _id: 1001 },
    { _id: 1, "items.productName": 1, "items.unitPrice": 1 }
  )
);

print("Histórico de alterações:");
database.product_price_history.find(
  { productId: 101 }
).sort({ changedAt: -1 }).forEach(printjson);


// 8. AVALIAÇÕES
print("\n=== 8. AVALIAÇÕES DE PRODUTOS ===");

database.reviews.insertMany([
  {
    _id: 1,
    productId: 101,
    customerId: 1,
    rating: 5,
    comment: "Produto excelente.",
    createdAt: diasAtras(4)
  },
  {
    _id: 2,
    productId: 101,
    customerId: 2,
    rating: 4,
    comment: "Atendeu às expectativas.",
    createdAt: diasAtras(3)
  },
  {
    _id: 3,
    productId: 102,
    customerId: 3,
    rating: 5,
    comment: "Bom custo-benefício.",
    createdAt: diasAtras(2)
  }
]);

database.reviews.find().forEach(printjson);


// 9. TRANSAÇÕES REAIS: COMMIT E ROLLBACK
print("\n=== 9. TESTES DE TRANSAÇÃO ===");

const hello = db.adminCommand({ hello: 1 });
const suportaTransacoes = Boolean(
  hello.setName || hello.msg === "isdbgrid"
);

if (!suportaTransacoes) {
  print("O servidor parece ser standalone.");
  print("Commit e rollback reais não foram executados.");
  print("Configure um replica set e execute novamente.");
} else {

  database.products.updateOne(
    { _id: 102 },
    { $set: { stock: 100, price: 80 } }
  );

  // TRANSAÇÃO COM SUCESSO
  const sessaoSucesso = db.getMongo().startSession();

  try {
    const bancoSessao =
      sessaoSucesso.getDatabase("vendas_mongodb");

    sessaoSucesso.startTransaction();

    const mouse = bancoSessao.products.findOne({ _id: 102 });

    if (!mouse || mouse.stock < 2) {
      throw new Error("Estoque insuficiente.");
    }

    bancoSessao.orders.insertOne({
      _id: 9001,
      customerId: 1,
      customerSnapshot: {
        name: "Ana Souza",
        email: "ana@example.com"
      },
      createdAt: new Date(),
      status: "completed",
      items: [
        {
          productId: 102,
          productName: "Mouse",
          quantity: 2,
          unitPrice: 80
        }
      ],
      total: 160,
      transactionTest: "commit"
    });

    bancoSessao.products.updateOne(
      { _id: 102 },
      { $inc: { stock: -2 } }
    );

    sessaoSucesso.commitTransaction();

    print("COMMIT confirmado.");
    print("Pedido 9001 criado e estoque reduzido em 2.");
  } catch (erro) {
    try {
      sessaoSucesso.abortTransaction();
    } catch (_) {}

    print("Erro na transação: " + erro.message);
  } finally {
    sessaoSucesso.endSession();
  }


  // TRANSAÇÃO COM FALHA DELIBERADA
  const sessaoRollback = db.getMongo().startSession();

  try {
    const bancoSessao =
      sessaoRollback.getDatabase("vendas_mongodb");

    sessaoRollback.startTransaction();

    bancoSessao.products.updateOne(
      { _id: 102 },
      { $inc: { stock: -5 } }
    );

    bancoSessao.orders.insertOne({
      _id: 9002,
      customerId: 2,
      customerSnapshot: {
        name: "Bruno Lima",
        email: "bruno@example.com"
      },
      createdAt: new Date(),
      status: "pending",
      items: [
        {
          productId: 102,
          productName: "Mouse",
          quantity: 5,
          unitPrice: 80
        }
      ],
      total: 400,
      transactionTest: "rollback"
    });

    // Falha intencional para demonstrar a reversão.
    throw new Error("Falha deliberada para demonstrar rollback.");

  } catch (erro) {
    try {
      sessaoRollback.abortTransaction();
      print("ROLLBACK executado após: " + erro.message);
    } catch (erroAbort) {
      print("Erro ao abortar: " + erroAbort.message);
    }
  } finally {
    sessaoRollback.endSession();
  }

  print("Pedido 9001 (deve existir):");
  printjson(database.orders.findOne({ _id: 9001 }));

  print("Pedido 9002 (deve ser null):");
  printjson(database.orders.findOne({ _id: 9002 }));

  print("Estoque final do Mouse:");
  printjson(
    database.products.findOne(
      { _id: 102 },
      { name: 1, stock: 1 }
    )
  );
}


// 10. RESUMO FINAL
print("\n=== 10. RESUMO DAS COLLECTIONS ===");

[
  "customers",
  "products",
  "orders",
  "product_price_history",
  "reviews"
].forEach(nome => {
  print(
    nome + ": " +
    database[nome].countDocuments() +
    " documentos"
  );
});

print("\n=== FIM DO SCRIPT ===");
print("Salve capturas de tela dos resultados para o relatório PDF.");