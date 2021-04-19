const
    { Server } = require("socket.io"),
    server = new Server(3000, {
        cors: {
            origin: '*',
            methods: 'GET',
            transports: ['websocket', 'polling'],
        },
        allowEIO3: true,
    });

const { ChatClient } = require("dank-twitch-irc");

server.on("connection", (socket) => {
    console.info(`Client connected [id=${socket.id}]`)
    socket.on("disconnect", () =>
        console.info(`Client gone [id=${socket.id}]`)
    );
});


let client = new ChatClient({
    username: "costadocet",
    password: "oauth:cojvccccmd07fgfyausw3w7chcqsin",
});
client.on("ready", () => console.log("Successfully connected to chat"));
client.on("close", (error) => {
    if (error != null) {
        console.error("Client closed due to error", error);
    }
});
const regex = /@(\w*)/gm;

client.on("PRIVMSG", (msg) => server.emit("twitch_chat", {
    owner: msg.senderUsername,
    text: msg.messageText,
    date: msg.serverTimestamp,
    targets: regex.exec(msg.messageText)
}));
client.on("USERNOTICE", (msg) => {
    if (msg.isSubgift()) {
        server.emit("twitch_sub", msg.senderUsername + "gifted to " + msg.eventParams.recipientUsername);
        return;
    }
});
client.connect();
client.join("costadocet");