pragma solidity ^0.4.15;


contract Owned {

  address public owner;

  event LogNewOwner (address _owner, address newOwner);

  modifier onlyOwner {
    if(msg.sender != owner) revert();
    _;
  }

  function Owned() {
      owner = msg.sender;
  }

  function changeOwner (address newOwner)
      onlyOwner
      returns(bool success){
        if (newOwner == 0) revert();
        LogNewOwner(owner, newOwner);
        owner = newOwner;
        return true;
      }
  }
