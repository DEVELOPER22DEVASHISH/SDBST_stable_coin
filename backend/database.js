const ethpricedb = require('./ethpricedb.json')
const  sdbstpricedb = require('./sdbstPrice.json')
const fs = require('fs').promises // we are going to manual call the function / it is asynchronous fn and promises to come with databses

const readDB = async (token) => {                 // either eth or dbst token
    if(token=='eth') {
        const output = await fs.readFile("ethpricedb.json", function (err, data) {
            if (err) throw err;
         return Buffer.from(data); // buffer is where the information is stored intially in the process
    })
    const pricedb = JSON.parse(output);
    return pricedb;

} else {
    const output = await fs.readFile("sdbstpricedb.json", function (err, data) {
        if (err) throw err;
     return Buffer.from(data); // buffer is where the information is stored intially in the process
})
const pricedb = JSON.parse(output);
return pricedb;
}
}  

const writeDb = async (price, time, Lastenrty,token) => { // last entry will be incremented
    let entry = {
        updateprice: price,
        timedate: time,
        entry: Lastenrty+1
    }
    if(token=="eth"){
        ethpricedb.push(entry);
        let output = await fs.writeFile("ethpricedb.json", JSON.stringify(ethpricedb), err => {
            if (err) throw err;
            return 'done';
        })
        return output;
    } else
      {
        sdbstpricedb.push(entry);
        let output = await fs.writeFile("sdbstPrice.json", JSON.stringify(sdbstpricedb), err => {
            if (err) throw err;
            return 'done';
        })
        return output;
    }
}

module.exports = { readDB, writeDb }