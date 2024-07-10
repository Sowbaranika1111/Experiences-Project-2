import express from 'express'
import { addTofav,removeFromFav,getFav } from '../controllers/favController.js'
import authMiddleware from '../middleware/auth.js';

const favRouter = express.Router();

favRouter.post("/add",   authMiddleware,addTofav)
favRouter.post("/remove",authMiddleware,removeFromFav)
favRouter.post("/list",  authMiddleware,getFav)

export default favRouter;