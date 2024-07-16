import express from "express"
import { loginUser , registerUser , getUserDetails} from "../controllers/userController.js" 


const userRouter = express.Router()

userRouter.post("/register",registerUser)
userRouter.post("/login",loginUser)
userRouter.get("/getUser",getUserDetails)


export default userRouter

// then set up this router in the server.js
