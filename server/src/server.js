import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { connectDb, disconnectDb } from "./config/db.js";
import authRoutes from "./routes/auth-routes.js";
import songRoutes from "./routes/song-routes.js";

dotenv.config();

connectDb();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/auth", authRoutes);
app.use("/api/song", songRoutes);

app.listen(port, "0.0.0.0", () => {
  console.log(`Server is running on port ${port}`);
});

process.on("unhandledRejection", (error) => {
  console.error("Unhandled Rejection:", error);
  server.close(async () => {
    await disconnectDb();
    process.exit(1);
  });
});

process.on("uncaughtException", async (error) => {
  console.error("Uncaught Exception:", error);
  await disconnectDb();
  process.exit(1);
});

process.on("SIGTERM", async () => {
  console.log("SIGTERM received");
  server.close(async () => {
    await disconnectDb();
    process.exit(1);
  });
});

//npx prisma init
//npx prisma migrate dev --name init
//npx prisma generate
