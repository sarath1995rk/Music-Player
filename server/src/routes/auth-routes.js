import { registerUser, loginUser,getUser } from "../controllers/auth-controller.js";
import express from "express";
import authMiddleware from "../middlewares/auth-middleware.js";

const router = express.Router();

router.post("/signup", registerUser);
router.post("/login", loginUser);
router.get("/user/me", authMiddleware, getUser);

export default router;
