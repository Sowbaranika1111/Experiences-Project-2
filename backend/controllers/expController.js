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

        const saveExpToDB = await experiences.save(); //this mthd isused to save data in the db
        res.json({ success: true, message: "Experience added" })
        console.log(saveExpToDB);

    }
    catch (error) {
        console.error("Error in addExp of expController.js: ", error.message);
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
        console.error("Error in listExp of expController.js: ", error.message);
        res.status(500).json({ success: false, message: "Error fetching experiences", error: error.message });
    }
}

const getUserExpDetailsProfilePg = async (req, res) => {
    const { email } = req.body;
    try {
        const userDataList = await expModel.find({ email });
        if (userDataList.length === 0) {
            return res.json({ success: false, message: "User did not share any experiences yet!" });
        } else {
            const data = userDataList.map(userData => ({
                id: userData._id,
                name: userData.name,
                age: userData.age,
                country: userData.country,
                profession: userData.profession,
                meditating_experience: userData.meditating_experience,
                exp_category: userData.exp_category,
                exp_desc: userData.exp_desc,
                video: userData.video
            }));

            return res.json({
                success: true,
                message: "User Experiences are found!",
                data: data
            });
        }
    } catch (e) {
        console.log(e);
        res.json({ success: false, message: "Error" });
    }
};

// remove experiences
const removeExp = async (req, res) => {
    const { _id } = req.body;
    try {
        const exp = await expModel.findById(_id);
        if (exp) {
            fs.unlink(`uploads/${exp.video}`, (err) => {
                if (err) console.error("Error deleting video file:", err);
            });

            await expModel.findByIdAndDelete(_id);
            res.json({ success: true, message: "Experience removed" });
        } else {
            res.json({ success: false, message: "Experience not found" });
        }
    } catch (error) {
        console.log(error);
        res.json({ success: false, message: "Error" });
    }
};


export { addExp, listExp, removeExp, getUserExpDetailsProfilePg }
//this goes to expRoute.js