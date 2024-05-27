use shopdb;

db.users.insertMany([
{"username":"admin","password":"8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"},
{"username":"korisnik1","password":"9ee012ea8322c151576408181941188fd1402d7ed343717578e96c446a812162","address":"ulica 1","email":"pera@mail.com","name":"pera peric","phone":"3434","place":"nis"}
])

db.products.insertMany([
{"pname":"adidas lopta","ptype":"oprema","pprice":"1500","pdesc":"fudbalska lopta broj 5","pstock":4},
{"pname":"srbija dres","ptype":"odeca","pprice":"10000","pdesc":"dres srbije sa evropskog prvenstva","pstock":5},
{"pname":"nike kopacke","ptype":"obuca","pprice":"8000","pdesc":"kopacke novi model","pstock":9}
])

db.orders.insertMany([
{"buyer":"korisnik1","product":"adidas lopta","amount":"1","cost":1500,"time":1662397122},
{"buyer":"korisnik1","product":"adidas lopta","amount":"2","cost":3000,"time":1662398018},
{"buyer":"korisnik1","product":"srbija dres","amount":"1","cost":10000,"time":1662398123},
{"buyer":"korisnik1","product":"adidas lopta","amount":"1","cost":1500,"time":1662398323},
{"buyer":"korisnik1","product":"nike kopacke","amount":"1","cost":8000,"time":1662398547},
{"buyer":"korisnik1","product":"nike kopacke","amount":"1","cost":8000,"time":1662398687},
{"buyer":"korisnik1","product":"nike kopacke","amount":"1","cost":8000,"time":1662398730},
{"buyer":"korisnik1","product":"nike kopacke","amount":"1","cost":8000,"time":1662398753},
{"buyer":"korisnik1","product":"nike kopacke","amount":"1","cost":8000,"time":1662399206},
{"buyer":"korisnik1","product":"adidas lopta","amount":"1","cost":1500,"time":1662399278}
]) 

db.messages.insertMany([
{"sender":"korisnik1","receiver":"admin","message":"Najbolje cene :D","time":"2022-09-05 16:58:58"}
])