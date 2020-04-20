pragma solidity ^0.5.11;

/// @title Dapp Idea Generator
/// @author Ann Kilzer
/// @notice You can call this contract for some inspiration for your next creative DApp
contract DappIdeaGenerator {
    
    uint256 private nonce;
    
    // keep track of the last time a user generates an idea for rate limiting
    mapping(address => uint256) private userToLastGeneration; 
    
    mapping(address => string[]) private userToIdea;
    
    string[] solidityFeatures = ["ERC20", "ERC721", "Burning", "payable functions"];
    string[] themes = ["ducks", "sharks", "pirates", "Japanese mascots", "kawaii", "hockey"];
    string[] categories = ["racing", "JRPG", "Corporate Training", "MMORPG", "simulator", "god game", "collector"];
    
    
    event NewIdea(
        string indexed category,
        string indexed theme,
        string indexed solidityFeature);
    
    /// @notice Pseudorandom function, vulnerable to miner manipulation, okay for lighthearted fun.
    // https://www.sitepoint.com/solidity-pitfalls-random-number-generation-for-ethereum/
    /// @return a number between 0 and 250
    function generateIdea() public {
        string memory category = categories[random(nonce) % categories.length];
        string memory theme = themes[random(nonce + 1) % themes.length];
        string memory solidityFeature = solidityFeatures[random(nonce + 2) % solidityFeatures.length];
        
        nonce = nonce + 3; // increment the nonce and save
        
        userToIdea[msg.sender] = [category, theme, solidityFeature];
        emit NewIdea(category, theme, solidityFeature);
    }
    
    function readIdea() public view returns (string memory category, string memory theme, string memory solidityFeature) {
        category = userToIdea[msg.sender][0];
        theme =  userToIdea[msg.sender][1];
        solidityFeature = userToIdea[msg.sender][2];
    }
    
    /// @notice Pseudorandom generator, vulnerable to miner manipulation, okay for lighthearted fun.
    /// https://www.sitepoint.com/solidity-pitfalls-random-number-generation-for-ethereum/
    /// @param seed a uint256 value 
    /// @return a random uint256
    function random(uint256 seed) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed, msg.sender)));
    }
}
