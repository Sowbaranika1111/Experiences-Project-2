import expModel from "../models/expModel.js";
import fs from 'fs'

// add experiences 

const addExp = async (req, res) => {
    let video_filename = `${req.file.filename}`

    const experiences = new expModel({
        name: req.body.name,
        email: req.body.email,
        age: req.body.age,
        profession: req.body.profession,
        country: req.body.country,
        meditating_experience: req.body.meditating_experience,
        exp_category: req.body.exp_category,
        exp_desc: req.body.exp_desc,
        video: video_filename
    })
    try {
        // throw new error("Simulated DB error") // to chk if the file is retained in the uploads

        const saveExpToDB = await experiences.save(); //this mthd isused to save data in the db

        if (saveExpToDB) {
            //Remove the videos from the uploads folder after saving it in database
            fs.unlink(`uploads/${video_filename}`, (err) => {
                if (err) {
                    console.error(`Failed to delete the file: ${video_filename}.Error:${err.message}`);
                }
                else {
                    console.log(`Successfully deleted the file: ${video_filename}`)
                }
            });
            res.json({ success: true, message: "Experience added" })
        }
        else {
            throw new Error("Failed to save experience to database");
        }
    }
    catch (error) {
        console.error("Error in addExp of expController.js: ",error.message);
        console.error("Full error object:", error);
        res.status(500).json({
            success: false,
            message: "Error saving experience to database. Video file is preserved in uploads folder.",
            error: error.message  // This will be sent to the client
        });     
    }
}

// displaying all the experiences video listed in the db
const listExp = async (req, res) => {
    try {
        const exps = await expModel.find({});
        res.json({ success: true, data: exps })
    }
    catch (error) {
        console.log("Error")
        res.json({ success: false, message: "Error" })
    }
}


// remove experiences
const removeExp = async (req, res) => {
    try {
        const exp = await expModel.findById(req.body.id);
        fs.unlink(`uploads/${exp.video}`, () => { }) //dlting vdo from uploads folder

        await expModel.findByIdAndDelete(req.body.id);
        res.json({ success: true, message: "Experience removed" });
    }
    catch (error) {
        console.log(error)
        res.json({ success: false, message: "Error" })
    }
}

export { addExp, listExp, removeExp }
//this goes to expRoute.js