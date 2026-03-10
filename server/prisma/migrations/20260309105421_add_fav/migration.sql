/*
  Warnings:

  - A unique constraint covering the columns `[userId,songId]` on the table `FavouriteSong` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "FavouriteSong_userId_songId_key" ON "FavouriteSong"("userId", "songId");
