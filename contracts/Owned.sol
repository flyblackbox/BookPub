pragma solidity ^0.4.6;


contract Owner {

  address public owner;
  event LogNewOwner (address owner, address newOwner);

  modifier onlyOwner {
    if(msg.sender != owner) throw;
    _;
  }

  function Owned() {
      owner = msg.sender
  }

  function changeOwner (address newOwner){
      onlyOwner
      returns(bool success){
        if (newOwner == 0) throw;
        LogNewOwner(owner, newOwner);
        owner = newOwner;
        return true;
      }
  }



}
