import { v2 as cloudinary } from "cloudinary";
import "dotenv/config";
// Configure cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const uploadMediaToCloudinary = (file) => {
  return new Promise((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream(
      {
        resource_type: "auto",
      },
      (error, result) => {
        if (error) {
          console.error("Error uploading to cloudinary", error);
          reject(error);
        } else {
          console.info("Media uploaded to cloudinary", result);
          resolve(result);
        }
      },
    );
    uploadStream.end(file.buffer);
  });
};

const deleteMediaFromCloudinary = async (publicId) => {
  try {
    const result = await cloudinary.uploader.destroy(publicId);
    console.info("Media deleted from cloudinary", result);
    return result;
  } catch (error) {
    console.error("Error deleting from cloudinary", error);
    throw error;
  }
};

export { uploadMediaToCloudinary, deleteMediaFromCloudinary };
