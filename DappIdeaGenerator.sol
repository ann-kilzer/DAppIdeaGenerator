pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

/// @title Dapp Idea Generator
/// @author Ann Kilzer
/// @notice You can call this contract for some inspiration for your next creative DApp
contract DappIdeaGenerator {

    uint256 private nonce;

    struct Idea {
        string solidityFeature;
        string theme;
        string category;
    }
    mapping(address => Idea) private userToIdea;

    string[] solidityFeatures = ["ERC20", "ERC721", "Burning", "payable functions"];
    string[] themes = ["ducks", "sharks", "pirates", "Japanese mascots", "kawaii", "hockey"];
    string[] categories = ["racing", "JRPG", "Corporate Training", "MMORPG", "simulator", "god game", "collector"];

    event NewIdea(address indexed sender, Idea idea);

    /// @notice Pseudorandom function, vulnerable to miner manipulation, okay for lighthearted fun.
    // https://www.sitepoint.com/solidity-pitfalls-random-number-generation-for-ethereum/
    /// @return a number between 0 and 250
    function generateIdea() public {
        Idea memory idea = Idea({
           category: categories[random(nonce) % categories.length],
           theme: themes[random(nonce + 1) % themes.length],
           solidityFeature: solidityFeatures[random(nonce + 2) % solidityFeatures.length]
        });
        userToIdea[msg.sender] = idea;
        emit NewIdea(msg.sender, idea);

        nonce = nonce + 3; // increment the nonce and save
    }

    function readIdea(address user) public view returns (Idea memory idea) {
        return userToIdea[user];
    }

    /// @notice Pseudorandom generator, vulnerable to miner manipulation, okay for lighthearted fun.
    /// https://www.sitepoint.com/solidity-pitfalls-random-number-generation-for-ethereum/
    /// @param seed a uint256 value
    /// @return a random uint256
    function random(uint256 seed) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed, msg.sender)));
    }
}
