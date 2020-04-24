pragma solidity ^0.5.11;

/// @title Dapp Idea Generator
/// @author Ann Kilzer
/// @notice You can call this contract for some inspiration for your next creative DApp
contract DappIdeaGenerator {

    uint256 public ideasGenerated;
    uint256 private nonce;

    // keep track of the last time a user generates an idea for rate limiting
    //mapping(address => uint256) private userToLastGeneration;

    mapping(address => string[]) private userToIdea;

    string[] solidityFeatures = ["ERC20", "ERC721", "Burning", "payable functions", "layering",
                                 "Summary transactions", "hash functions", "voting", "multisignature wallets",
                                 "timestamps"];
    string[] themes = ["ducks", "sharks", "pirates", "Japanese mascots", "kawaii", "hockey", "Noodles",
                        "Post-apocalyptic", "undersea", "Medieval", "fantasy", "football", "horses",
                        "dinosaurs", "pigeons", "farming", "snake people", "cooking", "gritty", "science fiction",
                        "pre-historic", "victorian", "yaks", "mobster", "bananas", "ninja", "goats", "romance",
                        "cars", "princess", "off-road", "hipster", "dystopian", "pizza",
                        "blade runner", "wild west", "froggy", "fashion", "trains", "draculas", "cyberpunk", "baking",
                        "wholesome", "trains"];
    string[] categories = ["racing", "JRPG", "Corporate Training", "MMORPG", "simulator", "god game", "collector",
                           "Player vs. Player fighter", "Mystery", "Puzzle", "Addictive click-to-win scheme",
                           "Role Playing Game", "Card game", "Tabletop (simulated)", "betting"];

    event NewDappIdea(
        string category,
        string theme,
        string solidityFeature);

    /// @notice creates a new idea for your weird Dapp
    function generateIdea() public {
        string memory category = categories[random(nonce) % categories.length];
        string memory theme = themes[random(nonce + 1) % themes.length];
        string memory solidityFeature = solidityFeatures[random(nonce + 2) % solidityFeatures.length];

        nonce = nonce + 3; // increment the nonce and save

        userToIdea[msg.sender] = [category, theme, solidityFeature];
        emit NewDappIdea(category, theme, solidityFeature);
        ideasGenerated = ideasGenerated + 1;
    }

    function readIdea() public view returns (string memory category, string memory theme, string memory solidityFeature) {
        if (userToIdea[msg.sender].length > 0) {
            category = userToIdea[msg.sender][0];
            theme =  userToIdea[msg.sender][1];
            solidityFeature = userToIdea[msg.sender][2];
        }
    }

    /// @notice Pseudorandom generator, vulnerable to miner manipulation, okay for lighthearted fun.
    /// https://www.sitepoint.com/solidity-pitfalls-random-number-generation-for-ethereum/
    /// @param seed a uint256 value
    /// @return a random uint256
    function random(uint256 seed) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed, msg.sender)));
    }
}
