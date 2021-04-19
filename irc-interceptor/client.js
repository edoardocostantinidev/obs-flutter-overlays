const
    io = require("socket.io-client"),
    ioClient = io.connect("ws://localhost:3000");

ioClient.on("twitch_chat", (msg) => console.info(msg));