import userModel from "../models/userModel.js";

const addDiaryNotes = async (req, res) => {
    const { email, title, desc } = req.body;

    try {
        // Use findOne to query by email
        let user = await userModel.findOne({ email: email });

        if (!user) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        const newNote = {
            title: title,
            desc: desc,
            date: new Date()
        };

        // If diaryData doesn't exist, initialize it as an empty object
        if (!user.diaryData) {
            user.diaryData = {};
        }

        // Generate a unique key for the new note (can use a timestamp or any unique identifier)
        const noteKey = Date.now().toString();

        // Add the new note to diaryData
        user.diaryData[noteKey] = newNote;

        await user.save();

        return res.status(200).json({
            success: true,
            message: 'Diary note added successfully',
            data: newNote
        });
    } catch (error) {
        console.error("Error adding diary note:", error);
        return res.status(500).json({ success: false, message: "Internal server error" });
    }
};

export { addDiaryNotes };
