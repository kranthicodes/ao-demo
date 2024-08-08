local aolib = require("aolib")

local cjson = aolib.json


VotingBucket = VotingBucket or {}


Handlers.add("CreateNewVote", Handlers.utils.hasMatchingTag("Action", "CreateNewVote"), function(msg)
    local title = msg.Tags.Title
    local options = cjson.decode(msg.Tags.Options)
    local id = tostring(msg.Timestamp)

    local votes = {}

    for _, option in pairs(options) do
        votes[option] = 0
    end

    VotingBucket[id] = {
        id = id,
        title = title,
        votes = votes
    }

    msg.reply({
        Action = "VoteCreated",
    })
end)

Handlers.add("Vote", Handlers.utils.hasMatchingTag("Action", "Vote"), function(msg)
    local option = msg.Tags.Option
    local id = tonumber(msg.Tags.Id)

    local vote = VotingBucket[id]

    if vote == nil then
        print(id, vote)
        error("Vote not found")
        return
    end

    vote.votes[option] = vote.votes[option] + 1

    msg.reply({
        Action = "VoteReceived",
        Vote = vote
    })
end)

Handlers.add("GetState", Handlers.utils.hasMatchingTag("Action", "GetState"), function(msg)
    msg.reply({
        Action = "State",
        State = cjson.encode(VotingBucket)
    })
end)
