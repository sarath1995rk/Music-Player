-- CreateTable
CREATE TABLE "Song" (
    "id" TEXT NOT NULL,
    "artist" TEXT NOT NULL,
    "songName" TEXT NOT NULL,
    "hexCode" TEXT NOT NULL,
    "songUrl" TEXT NOT NULL,
    "thumbnailUrl" TEXT NOT NULL,
    "songPublicId" TEXT NOT NULL,
    "thumbnailPublicId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Song_pkey" PRIMARY KEY ("id")
);
