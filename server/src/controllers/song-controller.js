import { prisma } from "../config/db.js";
import { uploadMediaToCloudinary } from "../utils/cloudinary.js";
import logger from "../utils/logger.js";

const uploadSong = async (req, res) => {
  try {
    logger.info("Uploading song", req.body);
    const { artist, songName, hexCode } = req.body;
    const songFile = req.files["song"][0];
    const thumbnailFile = req.files["thumbnail"][0];

    const [songUpload, thumbnailUpload] = await Promise.all([
      uploadMediaToCloudinary(songFile),
      uploadMediaToCloudinary(thumbnailFile),
    ]);

    // save to DB
    const newSong = await prisma.song.create({
      data: {
        artist,
        songName,
        hexCode,
        songUrl: songUpload.secure_url,
        thumbnailUrl: thumbnailUpload.secure_url,
        songPublicId: songUpload.public_id,
        thumbnailPublicId: thumbnailUpload.public_id,
        userId: req.user.id,
      },
    });

    logger.info("Song uploaded successfully", newSong);

    res.json({ message: "Song uploaded successfully", song: newSong });
  } catch (error) {
    logger.error("Error while uploading song", error);
    res.status(500).json({ message: "Failed to upload song" });
  }
};

const getAllSongs = async (req, res) => {
  try {
    logger.info("Getting all songs", req.user);
    const userId = req.user.id;

    // const songs = await prisma.song.findMany({
    //   where: {
    //     userId: userId,
    //   },
    //   include: {
    //     user: true,
    //   },
    // });

    const songs = await prisma.song.findMany();
    const songsWithOwnership = songs.map((song) => ({
      ...song,
      isMine: song.userId === userId,
      // isFavourite: song.favouriteSongs.some((fav) => fav.userId === userId),
    }));
    res.json({ success: true, songs: songsWithOwnership });
  } catch (error) {
    logger.error("Error while fetching songs", error);
    res.status(500).json({ message: "Failed to fetch songs" });
  }
};

const favUnFavSong = async (req, res) => {
  try {
    const userId = req.user.id;
    const songId = req.body?.songId;
    logger.info("Favourite song", songId);

    if (!songId) {
      return res.status(400).json({ message: "Song ID is required" });
    }
    const existingFavouriteSong = await prisma.favouriteSong.findUnique({
      where: {
        userId_songId: {
          userId,
          songId,
        },
      },
    });
    if (existingFavouriteSong) {
      await prisma.favouriteSong.delete({
        where: {
          id: existingFavouriteSong.id,
        },
      });
      logger.info("Song unfavourited successfully", existingFavouriteSong);
      return res.json({
        success: true,
        message: "Song unfavourited successfully",
        isFavourite: false,
      });
    }
    const favouriteSong = await prisma.favouriteSong.create({
      data: {
        userId,
        songId,
      },
    });
    logger.info("Favourite song created", favouriteSong);
    res.json({ success: true, favouriteSong, isFavourite: true });
  } catch (error) {
    logger.error("Error while favourite song", error);
    res
      .status(500)
      .json({ message: "Failed to favourite song", success: false });
  }
};

const getAllFavSongs = async (req, res) => {
  try {
    logger.info("Getting all favourite songs", req.user);
    const userId = req.user.id;
    const favouriteSongs = await prisma.favouriteSong.findMany({
      where: {
        userId,
      },
      include: {
        song: true,
      },
    });
    const finalSongs = favouriteSongs.map((favouriteSong) => ({
      ...favouriteSong.song,
      isMine: true,
    }));
    res.json({ success: true, songs: finalSongs });
  } catch (error) {
    logger.error("Error while fetching favourite songs", error);
    res.status(500).json({ message: "Failed to fetch favourite songs" });
  }
};

export { uploadSong, getAllSongs, favUnFavSong, getAllFavSongs };
