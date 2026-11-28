// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// LearnEnum — Enum: aik variable jo sirf kuch fixed options mein se aik ho sakti hai
contract LearnEnum {
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    Status public status;

    function get() public view returns (Status) {
        return status;
    }

    function set(Status _status) public {
        status = _status;
    }

    function cancel() public {
        status = Status.Canceled;
    }

    function reset() public {
        delete status;
    }
}
