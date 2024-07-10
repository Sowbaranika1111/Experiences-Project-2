import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    name: {type:String,required:true},
    email: {
        type:String,
        lowercase:true,
        required:true,
        unique:true},
    password: {type:String,required:true},
    favData:{type:Object,default:{}},
    diaryData:{type:Object,default:{}},
    gratitudeData:{type:Object,default:{}},
},{minimize:false})
// by default fav will be one empty object,only on setting minimize as false 
// if we didn't set to false this fava data won't be created since we didn't provide any data while creating

const userModel = mongoose.model.user || mongoose.model("user",userSchema)

export default userModel