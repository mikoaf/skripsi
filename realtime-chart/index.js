const express = require('express')
const webServer = express()
const port = 3000
const { webSocketServer, WebSocketServer } = require('ws')
const socketServer = new WebSocketServer({ port: 443 })
const { MongoClient } = require('mongodb')

const url = 'mongodb://mikoalfandi2801:mikoAF02@ac-apvm2wl-shard-00-00.vh02ftu.mongodb.net:27017,ac-apvm2wl-shard-00-01.vh02ftu.mongodb.net:27017,ac-apvm2wl-shard-00-02.vh02ftu.mongodb.net:27017/?ssl=true&replicaSet=atlas-njjdyu-shard-0&authSource=admin&retryWrites=true&w=majority'
const client = new MongoClient(url)

// Inisialisasi koneksi MongoDB saat server dimulai
async function initMongoDB() {
    try {
        await client.connect()
        console.log('Connected to MongoDB')
    } catch (error) {
        console.error('Error connecting to MongoDB:', error)
    }
}

initMongoDB()

webServer.use(express.static('public'))

webServer.get('/chart', (req, res) => {
    res.sendFile('chart.html', { root: __dirname })
})

webServer.listen(port, () => {
    console.log(`web server listening on port ${port}`)
})

const maxDataPoints = 500

socketServer.on('connection', ws => {
    console.log('new client connected')
    async function getEKG() {
        try {
            const data = await client.db('ekgApp').collection('ekg').find({}).sort({ _id: -1 }).limit(maxDataPoints).toArray()
            const reversedData = data.reverse()
            ws.send(JSON.stringify(reversedData))
        } catch (error) {
            console.error('Error fetching data from MongoDB:', error)
        }
    }
    ws.on('message', message => {
        switch (JSON.parse(message).type) {
            case 'load':
                getEKG()
                break;
        }
    })
})