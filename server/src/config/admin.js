// import AdminJS from "adminjs";
// import AdminJSExpress from "@adminjs/express";
// import { Database, Resource, getModelByName } from "@adminjs/prisma";
// import { prisma } from "./db.js";

// AdminJS.registerAdapter({ Database, Resource });

// const admin = new AdminJS({
//   resources: [
//     {
//       resource: { model: getModelByName("User"), client: prisma },
//       options: {
//         properties: {
//           password: { isVisible: false }, // hide password field
//         },
//       },
//     },
//     // add more models here e.g. getModelByName("Song")
//   ],
//   rootPath: "/admin",
// });

// const adminRouter = AdminJSExpress.buildAuthenticatedRouter(admin, {
//   authenticate: async (email, password) => {
//     // hardcode admin credentials or check DB
//     if (
//       email === process.env.ADMIN_EMAIL &&
//       password === process.env.ADMIN_PASSWORD
//     ) {
//       return { email };
//     }
//     return null;
//   },
//   cookiePassword: process.env.SESSION_SECRET || "some-secret-key",
// });

// export { admin, adminRouter };
