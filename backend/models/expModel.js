//using these models we can store the products in the db

import mongoose from "mongoose";

//to describe the exp model properties we create a schema

const expSchema = new mongoose.Schema({
    name: {type:String,required:true},
    email: {type:String,required:true},
    age:{type:String,required:true},
    profession:{type:String,required:true},
    country:{type:String,required:true},
    meditating_experience:{type:String,required:true},
    exp_category:{type:String,required:true},
    video:{type:String,required:true},
    exp_desc:{type:String,required:true}
})

// using the above schema , we create a model

const expModel = mongoose.model.experiences || mongoose.model("experiences",expSchema);

export default expModel

//this goes to expController