# ChatThroughApp
## chat "middle server" between 2 users of Slack

- Users come on website and register (any simple registration works)
- Then they click on "add to slack" for our new slack app called "ChatThroughApp"
- After that a page opens with a list of registered users. Select any other User (previously registered) and start chatting through Slack
- In User's slack account new channel (not direct message) is created with userName of selected User "eg. Chat with User B"
- They can exchange messages on that channel with each other. Chat happens through our own server - all messages are routed through "our server" (with bots)
- All messages are stored in your db as well
- Host on AWS or digitalocean or linode
