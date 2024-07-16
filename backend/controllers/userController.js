import userModel from "../models/userModel.js";
import jwt from "jsonwebtoken"
import bcrypt from "bcrypt"
import validator from "validator"


//! login user
const loginUser = async (req, res) => {
    const { email, password } = req.body;
    try {
        const user = await userModel.findOne({ email });
        if (!user) {
            return res.json({ success: false, message: "User doesn't exist! Do register" })
        }

        const isMatch = await bcrypt.compare(password, user.password)

        if (!isMatch) {
            return res.json({ success: false, message: "Invalid Credentials" })
        }

        const token = createToken(user._id);
        res.json({ success: true, tokenValue: token, user: { name: user.name, email: user.email } })

    } catch (error) {
        console.log(error);
        res.json({ success: false, message: "Error" })
    }
}

//create and send the token using the response to the user
// defined an env variable JWT_SECRET
const createToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET)
}

//! register user
const registerUser = async (req, res) => {
    const { name, password, email } = req.body;
    try {
        const exists = await userModel.findOne({ email });

        if (exists) {
            return res.json({ success: false, message: "User already exists" })
        }

        // validating email format and strong password
        if (!validator.isEmail(email)) {
            return res.json({ success: false, message: "Please enter a valid email" })
        }
        if (password.length < 8) {
            return res.json({ success: false, message: "Please enter a strong password" })
        }

        // hasing user password
        const salt = await bcrypt.genSalt(10)
        const hashedPassword = await bcrypt.hash(password, salt) //to hash the pwrd , provide the pwrd and the salt

        const newUser = new userModel({
            name: name,
            email: email,
            password: hashedPassword
        })

        const user = await newUser.save()
        const token = createToken(user._id)
        res.json({ success: true, token, user: { name: user.name, email: user.email } })
    } catch (error) {
        console.log(error);
        res.json({ success: false, message: "Error" })
    }
}

//! get user details
const getUserDetails = async (req, res) => {
    const token = req.headers.authorization.split(' ')[1];
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user = await userModel.findById(decoded.id);
        if (!user) {
            return res.status(404).json({ success: false, message: "User not found" });
        }
        res.json({ success: true, user: { name: user.name, email: user.email } });
    } catch (error) {
        console.log(error);
        res.status(401).json({ success: false, message: "Unauthorized" });
    }
}

export { loginUser, registerUser, getUserDetails }