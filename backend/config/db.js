import mongoose from "mongoose";

// to access this conn we are exporting to use in the server.js file
export const connectDB = async () => {
    await mongoose.connect('mongodb+srv://Sowbaranika:111111111@cluster0.8vgqysd.mongodb.net/Experiences-prjt').then(()=>console.log("DB Connected"));
}
