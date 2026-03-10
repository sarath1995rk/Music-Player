import express from "express";
import multer from "multer";
import {
  uploadSong,
  getAllSongs,
  favUnFavSong,
  getAllFavSongs,
} from "../controllers/song-controller.js";
import authMiddleware from "../middlewares/auth-middleware.js";

//configure multer for upload file
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 },
}).fields([
  { name: "song", maxCount: 1 },
  { name: "thumbnail", maxCount: 1 },
]);
const router = express.Router();

router.post(
  "/upload",
  authMiddleware,
  (req, res, next) => {
    upload(req, res, function (err) {
      if (err instanceof multer.MulterError) {
        console.error("Multer error while uploading file", err);
        return res.status(400).json({
          success: false,
          message: "Multer error while uploading",
          error: err?.message,
          stack: err.stack,
        });
      } else if (err) {
        console.error("Error while uploading file", err);
        return res.status(500).json({
          success: false,
          message: "Error while uploading",
          error: err?.message,
          stack: err.stack,
        });
      }
      if (!req.files || !req.files["song"] || !req.files["thumbnail"]) {
        console.warn("No file uploaded");
        return res.status(400).json({
          success: false,
          message: "No file uploaded",
        });
      }
      next();
    });
  },
  uploadSong,
);

router.get("/all", authMiddleware, getAllSongs);

router.post("/favourite", authMiddleware, favUnFavSong);

router.get("/favourite", authMiddleware, getAllFavSongs);

export default router;
