import jwt from "jsonwebtoken";
import { prisma } from "../config/db.js";

const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Authentication failed" });
    }
    const token = authHeader.split(" ")[1];
    const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
    const user = await prisma.user.findUnique({
      where: { id: decodedToken.id },
    });
    if (!user) {
      return res.status(401).json({ message: "Authentication failed" });
    }
    req.user = { ...user, password: undefined };
    next();
  } catch (error) {
    res.status(401).json({ message: "Authentication failed" });
  }
};

export default authMiddleware;
