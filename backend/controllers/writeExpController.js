import userModel from "../models/userModel.js";

const addWriteExp = async(req,res) => {
    try{
        let userData = await userModel.findOne({_id:req.body.userId})
        let writeExpData = await userData.writeExpData

        
    }
    catch(error){
        console.log(error);
        res.json({success:false,message:"Error"})
    }
}