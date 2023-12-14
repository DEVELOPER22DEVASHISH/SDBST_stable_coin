//checking price and storing the price in database 
// will call getPrice function and database 


const { getEthPrice, getSDBSTPrice } = require('./getprices');
const { readDB, writeDb } = require('./database');

const getDBData = async (token) => {
    let fromoutput = await readDB(token).catch((error) => {console.log(error)});
    let chartprice = [];
    let charttime = []; // time gonna be store in order
    let chartentry = []; //
    if (fromoutput != undefined) {
        fromoutput.forEach((value)=> {
            chartprice.push(value.updateprice)
            charttime.push(value.timedate);
            chartentry.push(value.entry);
        })

    }

    return { chartprice, charttime, chartentry}
}

const storeEthPrice = async () => {
    const token = 'eth';
    let price = await getEthPrice();
    const fetchtime = new Date();
    const time = 
        fetchtime.getHours() + ':' + fetchtime.getMinutes() + ':' + fetchtime.getSeconds();

    const fetchlast = await getDBData(token);
    let rawlastentry = fetchlast.chartentry;
    if(rawlastentry.length ==0) {
        let entry = 0;
        await writeDb(price, time, entry ,token).catch((error) => {console.log(error)});

    }  
    else if (rawlastentry.length > 0) {
        let lastentry = rawlastentry[rawlastentry.length-1];
        await writeDb(price, time, lastentry ,token).catch((error) => {console.log(error)});

    } 
}

storeEthPrice()

const storeSDBSTPrice = async () => {
    const token = 'SDBST';
    let price = await getSDBSTPrice();
    const fetchtime = new Date();
    const time = 
        fetchtime.getHours() + ':' + fetchtime.getMinutes() + ':' + fetchtime.getSeconds();

    const fetchlast = await getDBData(token);
    let rawlastentry = fetchlast.chartentry;
    if(rawlastentry.length ==0) {
        let entry = 0;
        await writeDb(price, time, entry ,token).catch((error) => {console.log(error)});

    }  
    else if (rawlastentry.length > 0) {
        let lastentry = rawlastentry[rawlastentry.length-1];
        await writeDb(price, time, lastentry ,token).catch((error) => {console.log(error)});

    } 
}

storeSDBSTPrice()


module.exports = { getDBData, storeEthPrice, storeSDBSTPrice }