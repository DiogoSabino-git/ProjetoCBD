use('AdventurWorksWeb');

db.access_logs.drop();

db.access_logs.insertMany([
    {
      "user_email": "aaron18@adventure-works.com",
      "timestamp": "2025-12-16T00:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.98",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron47@adventure-works.com",
      "timestamp": "2025-12-15T14:32:05.923",
      "action": "UPDATE_PROFILE",
      "ip_address": "192.168.1.206",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron21@adventure-works.com",
      "timestamp": "2025-12-14T07:32:05.923",
      "ip_address": "192.168.1.225",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron45@adventure-works.com",
      "timestamp": "2025-12-14T01:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.178",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron39@adventure-works.com",
      "timestamp": "2025-12-13T03:32:05.923",
      "ip_address": "192.168.1.243",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron54@adventure-works.com",
      "timestamp": "2025-12-12T13:32:05.923",
      "action": "VIEW_REPORT",
      "ip_address": "192.168.1.229",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron35@adventure-works.com",
      "timestamp": "2025-12-12T01:32:05.923",
      "action": "VIEW_REPORT",
      "ip_address": "192.168.1.189",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron27@adventure-works.com",
      "timestamp": "2025-12-11T04:32:05.923",
      "action": "UPDATE_PROFILE",
      "ip_address": "192.168.1.28",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron31@adventure-works.com",
      "timestamp": "2025-12-11T03:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.52",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron4@adventure-works.com",
      "timestamp": "2025-12-10T22:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.226",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron32@adventure-works.com",
      "timestamp": "2025-12-10T11:32:05.923",
      "ip_address": "192.168.1.147",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron50@adventure-works.com",
      "timestamp": "2025-12-10T11:32:05.923",
      "ip_address": "192.168.1.204",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron44@adventure-works.com",
      "timestamp": "2025-12-10T10:32:05.923",
      "ip_address": "192.168.1.184",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron40@adventure-works.com",
      "timestamp": "2025-12-10T09:32:05.923",
      "ip_address": "192.168.1.187",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron23@adventure-works.com",
      "timestamp": "2025-12-09T22:32:05.923",
      "ip_address": "192.168.1.196",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron25@adventure-works.com",
      "timestamp": "2025-12-07T06:32:05.923",
      "ip_address": "192.168.1.152",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron26@adventure-works.com",
      "timestamp": "2025-12-06T21:32:05.923",
      "ip_address": "192.168.1.209",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron33@adventure-works.com",
      "timestamp": "2025-12-05T06:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.252",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron17@adventure-works.com",
      "timestamp": "2025-12-05T05:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.91",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron28@adventure-works.com",
      "timestamp": "2025-12-04T03:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.55",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron42@adventure-works.com",
      "timestamp": "2025-12-01T23:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.234",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron43@adventure-works.com",
      "timestamp": "2025-12-01T16:32:05.923",
      "ip_address": "192.168.1.52",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron12@adventure-works.com",
      "timestamp": "2025-12-01T07:32:05.923",
      "ip_address": "192.168.1.132",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron53@adventure-works.com",
      "timestamp": "2025-12-01T04:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.220",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron38@adventure-works.com",
      "timestamp": "2025-11-30T11:32:05.923",
      "ip_address": "192.168.1.223",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron11@adventure-works.com",
      "timestamp": "2025-11-30T11:32:05.923",
      "ip_address": "192.168.1.253",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron30@adventure-works.com",
      "timestamp": "2025-11-30T10:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.212",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron55@adventure-works.com",
      "timestamp": "2025-11-30T01:32:05.923",
      "action": "UPDATE_PROFILE",
      "ip_address": "192.168.1.196",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron46@adventure-works.com",
      "timestamp": "2025-11-29T13:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.6",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron37@adventure-works.com",
      "timestamp": "2025-11-28T23:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.10",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron16@adventure-works.com",
      "timestamp": "2025-11-26T15:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.1",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron22@adventure-works.com",
      "timestamp": "2025-11-26T15:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.212",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron52@adventure-works.com",
      "timestamp": "2025-11-26T04:32:05.923",
      "ip_address": "192.168.1.134",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron48@adventure-works.com",
      "timestamp": "2025-11-25T05:32:05.923",
      "ip_address": "192.168.1.207",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron36@adventure-works.com",
      "timestamp": "2025-11-25T02:32:05.923",
      "action": "VIEW_REPORT",
      "ip_address": "192.168.1.253",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron49@adventure-works.com",
      "timestamp": "2025-11-25T00:32:05.923",
      "action": "VIEW_REPORT",
      "ip_address": "192.168.1.115",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron15@adventure-works.com",
      "timestamp": "2025-11-24T21:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.79",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron5@adventure-works.com",
      "timestamp": "2025-11-23T17:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.68",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron20@adventure-works.com",
      "timestamp": "2025-11-23T10:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.217",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron6@adventure-works.com",
      "timestamp": "2025-11-23T03:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.88",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron29@adventure-works.com",
      "timestamp": "2025-11-22T18:32:05.923",
      "action": "VIEW_REPORT",
      "ip_address": "192.168.1.135",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron24@adventure-works.com",
      "timestamp": "2025-11-22T18:32:05.923",
      "ip_address": "192.168.1.76",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron34@adventure-works.com",
      "timestamp": "2025-11-22T12:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.52",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron14@adventure-works.com",
      "timestamp": "2025-11-22T08:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.123",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron13@adventure-works.com",
      "timestamp": "2025-11-21T20:32:05.923",
      "ip_address": "192.168.1.107",
      "status": "FAILURE"
    },
    {
      "user_email": "aaron3@adventure-works.com",
      "timestamp": "2025-11-21T07:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.144",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron10@adventure-works.com",
      "timestamp": "2025-11-20T17:32:05.923",
      "action": "LOGIN",
      "ip_address": "192.168.1.33",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron19@adventure-works.com",
      "timestamp": "2025-11-20T17:32:05.923",
      "action": "LOGOUT",
      "ip_address": "192.168.1.208",
      "status": "FAILURE"
    },
    {
      "user_email": "aaron51@adventure-works.com",
      "timestamp": "2025-11-17T11:32:05.923",
      "ip_address": "192.168.1.153",
      "status": "SUCCESS"
    },
    {
      "user_email": "aaron41@adventure-works.com",
      "timestamp": "2025-11-17T03:32:05.923",
      "action": "VIEW_REPORT",
      "ip_address": "192.168.1.112",
      "status": "SUCCESS"
    }
]);

// Queries

//Resultado excluindo valores omissos e ordenado
console.log("--- Query A: Logs com IP, ordenados por data ---");
const queryA = db.access_logs.find(
    { "ip_address": { $ne: null } } 
).sort(
    { "timestamp": -1 } 
);
console.log(queryA);


//Envolve uma filtragem
console.log("--- Query B: Apenas tentativas falhadas (FAILURE) ---");
const queryB = db.access_logs.find(
    { "status": "FAILURE" }
);
console.log(queryB);


//Envolve uma agregação
console.log("--- Query C: Contagem de ações por tipo ---");
const queryC = db.access_logs.aggregate([
    {
        $group: {
            _id: "$action",       // Agrupar pelo tipo de ação
            total: { $sum: 1 }    // Contar quantos registos
        }
    },
    {
        $sort: { total: -1 }      // Ordenar do mais frequente para o menos
    }
]);
console.log(queryC);