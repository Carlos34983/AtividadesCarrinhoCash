db = db.getSiblingDB("ticketcore");

if (db.customers.countDocuments() === 0) {
    db.customers.insertMany([
        {
            _id: 1,
            name: "Ana Souza",
            email: "ana@example.com",
            document: "12345678901"
        },
        {
            _id: 2,
            name: "Carlos Lima",
            email: "carlos@example.com",
            document: "23456789012"
        },
        {
            _id: 3,
            name: "Mariana Alves",
            email: "mariana@example.com",
            document: "34567890123"
        }
    ]);
}

if (db.venues.countDocuments() === 0) {
    db.venues.insertMany([
        {
            _id: 1,
            name: "Arena Central",
            city: "Curitiba",
            capacity: 5000
        },
        {
            _id: 2,
            name: "Teatro Municipal",
            city: "Guarapuava",
            capacity: 800
        }
    ]);
}

if (db.events.countDocuments() === 0) {
    db.events.insertMany([
        {
            _id: 1,
            name: "Festival de Música",
            venue_id: 1,
            date: ISODate("2026-11-20T20:00:00Z"),
            status: "published"
        },
        {
            _id: 2,
            name: "Show Acústico",
            venue_id: 2,
            date: ISODate("2026-12-05T19:00:00Z"),
            status: "published"
        }
    ]);
}

print("Dados iniciais inseridos ou já existentes.");
print("Clientes: " + db.customers.countDocuments());
print("Locais: " + db.venues.countDocuments());
print("Eventos: " + db.events.countDocuments());
