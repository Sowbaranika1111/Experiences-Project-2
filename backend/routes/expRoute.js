import express from "express"
import { addExp, listExp, removeExp } from "../controllers/expController.js"
import multer from "multer" //to create video storage system

//creating express router to create get mthd / post mthd / many other mthds
const expRouter = express.Router();

// to save the videos in the uploads folder
// Image Storage Engine
// creating storage using multer disk storage mthd

const storage = multer.diskStorage({
    destination: "uploads",
    filename: (req, file, cb) => {
        const ext = file.mimetype.split("/")[1];
        //return cb(null,`${Date.now()}${file.originalname}`) //to ceate a unique file name everytime
        cb(null, `${Date.now()}.${ext}`);
    }
});

// creating middleware upload 
const upload = multer({ storage: storage })


const handleMulterError = (err, req, res, next) => {
    if (err instanceof multer.MulterError) {
        return res.status(400).json({ success: false, message: "File Upload Error : " + err.message })
    }
    else if (err) {
        return res.status(400).json({ success: false, message: "Some error occured : " + err.message })
    }
    next();
}

expRouter.post("/add", upload.single("video"), handleMulterError, addExp) 

// to display
expRouter.get("/list", listExp)
// to remove
expRouter.post("/remove", removeExp)



// uploadCheck = upload.single("video")

// try{
//     if (uploadCheck) {
//         // sending form data to the server using post mthd ("an end-point address")
//         expRouter.post("/add", upload.single("video"), addExp)
//     }
// }
// catch(error){
//     console.log(error)
//     res.json({success:false,message:"Video is not uploaded!"})
// }

export default expRouter;

// then setting this up in the server.js file (api endpoints)

