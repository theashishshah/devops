import express from "express";

const PORT = 9999

const app = express()

app.get("/", (req, res) => {
    console.log("Hello, thank you for visiting")
    return res.status(200).json({
        success: true,
        message: "Thank you for visiting us!"
    })
})

app.get("/health", (req, res) => {
    console.log("Good health")
    return res.status(200).json({
        status: true,
        message: "Good health"
    })
})


app.listen(PORT, "0.0.0.0", () =>  console.log("Server is running on port ", PORT))