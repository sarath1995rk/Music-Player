import { prisma } from "../config/db.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import logger from "../utils/logger.js";

const registerUser = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    logger.info("Registering user", { name, email, password });
    if (!name || !email || !password) {
      return res.status(400).json({ message: "All fields are required" });
    }
    //check if user already exists
    const user = await prisma.user.findUnique({ where: { email } });
    if (user) {
      return res.status(400).json({ message: "User already exists" });
    }

    //hash password
    const salt = await bcrypt.genSalt(Number(process.env.SALT_ROUNDS));
    const hashedPassword = await bcrypt.hash(password, salt);

    //create user
    const newUser = await prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
      },
    });

    logger.info("User registered successfully", {
      ...newUser,
      password: undefined,
    });
    res.status(201).json({ ...newUser, password: undefined });
  } catch (error) {
    logger.error("Error while registering user", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    logger.info("Logging in user", email);
    if (!email || !password) {
      return res.status(400).json({ message: "All fields are required" });
    }
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: "Invalid password" });
    }

    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRES_IN,
    });

    res.status(200).json({ ...user, password: undefined, token });
  } catch (error) {
    logger.error("Error while logging in user", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const getUser = async (req, res) => {
  try {
    logger.info("Getting user", req.user);
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      include: {
        favouriteSongs: true, // ✅ include favorites
      },
    });
    res
      .status(200)
      .json({ ...user, password: undefined, favorites: user.favouriteSongs });
  } catch (error) {
    logger.error("Error while getting user", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

export { registerUser, loginUser, getUser };
