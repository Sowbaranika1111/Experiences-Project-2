// if user send the data , token is used to authenticate them , 
// to decode the token we use the middleware
import jwt from "jsonwebtoken"

const authMiddleware = async (req, res, next) => {
    // get the token from user using header, then restructure the token from req.header

    const {token} = req.headers;
    if (!token) {
        return res.json({success:false,message:"Not Authorized! Login Again"})
    }
    try{
        const token_decode = jwt.verify(token,process.env.JWT_SECRET)
        req.body.userId = token_decode.id;
        next(); //this is a callback func
    }
    catch(error){
        console.log(error)
        res.json({success:false,message:"Error"})
    }
}

export default authMiddleware