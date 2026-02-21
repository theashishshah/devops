import express from "express"

const app = express()
const port = 9999


app.get("/api", async (_req, res) => {
    await new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve()
        }, 2*1000);
    })

    res.send("Hello from server.")
})

app.listen(port, "0.0.0.0",() => {
    console.log("Server is running on port 9999")
})