import express from "express";
import { addDiaryNotes } from "../controllers/diaryController.js";

const diaryRouter = express.Router()

diaryRouter.post("/add",addDiaryNotes)

export default diaryRouter