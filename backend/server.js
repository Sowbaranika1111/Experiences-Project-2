//Creating express server

import express from "express"
import cors from "cors"
import { connectDB } from "./config/db.js"
import expRouter from "./routes/expRoute.js"
import userRouter from "./routes/userRoute.js"
import diaryRouter from "./routes/diaryRouter.js"
import 'dotenv/config'

//app config
const app = express()
const port = 4000


//middleware
app.use(express.json()) //using this middleware req from front-end to back-end will be parsed using json
app.use(cors()) // to access any backend from frontend

// db connection
connectDB();

// api endpoints        (experiences is the model name.. expModel.js)
app.use("/api/experiences",expRouter)

// showing the uploaded vdos on the front-end using the url which is stored in the db
app.use("/videos",express.static('uploads')) //mounting uploads to videos(anyName) for accessing 
// app.use("/uploads",express.static('uploads'))
// run localhost:4000/videos/file name stored in the uploads

app.use("/api/user",userRouter)

app.use("/api/diary",diaryRouter)

//When we hit the end point , we get this msg 
app.get("/",(req,res)=>{ //using this req we are creating one response=>
    res.send("API Working")
}) 

//to run express server , we use app.listen and provide 'port' number
app.listen(port,()=>{
    console.log(`Server Started on http://localhost:${port}`)
})


