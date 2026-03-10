-- CreateTable
CREATE TABLE "FavouriteSong" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "songId" TEXT NOT NULL,

    CONSTRAINT "FavouriteSong_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "FavouriteSong" ADD CONSTRAINT "FavouriteSong_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FavouriteSong" ADD CONSTRAINT "FavouriteSong_songId_fkey" FOREIGN KEY ("songId") REFERENCES "Song"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
