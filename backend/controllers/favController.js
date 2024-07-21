import userModel from '../models/userModel.js';

// add videos to user fav
const addTofav = async (req, res) => {
    try {
        let userData = await userModel.findOne({ _id: req.body.userId })
        let favData = await userData.favData

        const videoId = req.body.videoId

        if (!favData[videoId]) {
            favData[videoId] = true;
        }
        await userModel.findByIdAndUpdate(req.body.userId, { favData })
        res.json({ success: true, message: "Added to favourites!" })
    }
    catch (error) {
        console.log(error)
        return res.json({ success: false, message: "Error" })
    }
}

// remove videos from user fav

const removeFromFav = async (req, res) => {
    let userData = await userModel.findById(req.body.userId) //userId is from middleware that will decode the token and convert it and get this id
    let favData = await userData.favData
    const videoId = req.body.videoId
    if (favData[videoId]) {
        delete favData[videoId]
    }

    await userModel.findByIdAndUpdate(req.body.userId, { favData })
    return res.json({ success: true, message: "Removed from favourites!" })

}

// fetch user fav data

const getFav = async (req, res) => {
    try {
        let userData = await userModel.findById(req.body.userId)
        let favData = await userData.favData
        res.json({success:true,favData})
    }
    catch (error) {
        console.log(error)
        res.json({success:false,message:"Error"})
    }
}

export { addTofav, removeFromFav, getFav }