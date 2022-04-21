//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Blog {
   string public name;
   address public owner;

   using Counters for Counters.Counter;

   Counters.Counter private _postIds;

   struct Post {
       uint id;
       string title;
       string content; //IPFS hash
       bool published;
   }

mapping(uint=>Post) private idToPost;
mapping(string=>Post) private hashToPost;

event PostCreated(uint id,string title,string hash);
event PostUpdated(uint id,string title,string hash,bool published);

constructor(string memory _name){
    console.log("Deploying Blog With Name:",_name);
    name = _name;
    owner = msg.sender;
}

 /* updates the blog name */
 function updateName(string memory _name) public {
   name = _name;
 }

 /* transfers ownership of the contract to another address */
function transferOwnership(address newOwner) public onlyOwner {
   owner = newOwner;
}


/* fetches an individual post by the content hash */
function fetchPost(string memory hash) public view returns(Post memory){
  return hashToPost[hash];
}

 /* creates a new post */
function createPost(string memory title, string memory hash) public onlyOwner {
    _postIds.increment();
    uint postId = _postIds.current();
    Post storage post = idToPost[postId];
    post.id = postId;
    post.title = title;
    post.published = true;
    post.content = hash;
    hashToPost[hash] = post;
    emit PostCreated(postId, title, hash);
}

/* updates an existing post */
function updatePost(uint postId, string memory title, string memory hash, bool published) public onlyOwner {
    Post storage post =  idToPost[postId];
    post.title = title;
    post.published = published;
    post.content = hash;
    idToPost[postId] = post;
    hashToPost[hash] = post;
    emit PostUpdated(post.id, title, hash, published);
}

/* fetches all posts */
function fetchPosts() public view returns (Post[] memory) {
    uint itemCount = _postIds.current();

    Post[] memory posts = new Post[](itemCount);
    for (uint i = 0; i < itemCount; i++) {
        uint currentId = i + 1;
        Post storage currentItem = idToPost[currentId];
        posts[i] = currentItem;
    }
    return posts;
}

/* this modifier means only the contract owner can */
/* invoke the function */
modifier onlyOwner() {
      require(msg.sender == owner);
    _;
}

}