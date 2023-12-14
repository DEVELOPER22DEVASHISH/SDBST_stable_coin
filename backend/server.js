const express = require('express');
const app = express();
const cors= require('cors');

const corsOptions = {
    origin: '*',
    optionSuccessStatus:200,
}

app.use(cors(corsOptions))
app.use(require('body-parser').json());

const sdbstlogo = `
███╗   ██╗██████╗ ██████╗ ███████╗██╗  ██╗
████╗  ██║╚════██╗██╔══██╗██╔════╝╚██╗██╔╝
██╔██╗ ██║ █████╔╝██║  ██║█████╗   ╚███╔╝ 
██║╚██╗██║██╔═══╝ ██║  ██║██╔══╝   ██╔██╗  // copy paste the logo from the project 
██║ ╚████║███████╗██████╔╝███████╗██╔╝ ██╗
╚═╝  ╚═══╝╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝
`

const { getDBData, storeEthPrice, storeSDBSTPrice} = require('./interface');

app.post("/getchartinfo", function (req, res) {
    const token = req.body.token;
    return new Promise((resolve, reject) => {
      getDBData(token).then((response) => {
      res.statusCode = 200;
      res.setHeader("Content-Type", "application/json");
      res.setHeader("Cache-Control", "max-age=180000");
      res.end(JSON.stringify(response));
      resolve();
    }).catch((error) => {
      res.json(error);
      res.status(405).end();
    });
});
});

const refreshEthPrice = async () => {
    setInterval(function () {
        storeEthPrice();
    }, 120000) // every 2 minutes it will get refreshed // in milisecond
}

const refreshSDBSTPrice = async () => {
    setInterval(function () {
        storeSDBSTPrice();
    }, 120000)
}

const server = app.listen(8082, function() {
    const port = server.address().port;
    console.log('')
    console.log(sdbstlogo);
    console.log('')
    refreshEthPrice()
    refreshSDBSTPrice()
    console.log('Backend API Listening on Port: ' + port)
})
