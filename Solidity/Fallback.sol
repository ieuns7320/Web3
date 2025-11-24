// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Fallback {
    // event: 함수 이름과 남은 가스량을 로그로 기록
    event Log(string func, uint256 gas);

    // fallback()
    // - 컨트랙트에 정의되지 않은 함수가 호출되거나, 데이터가 담긴 트랜잭션이 전송될 때 실행됨
    // - 반드시 external 및 payable로 선언 (이더 수신 가능)
    // - send/transfer: gas 2300만 전달, call: 모든 gas 전달
    fallback() external payable {
        emit Log("fallback", gasleft());
    }

    // receive()
    // - msg.data(입력 데이터)가 비어있는 단순 이더 전송 시 호출됨
    // - 반드시 external 및 payable로 선언 (이더 수신 가능)
    receive() external payable {
        emit Log("receive", gasleft());
    }

    // getBalance(): 이 컨트랙트의 현재 이더 잔고를 반환
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SendToFallback {
    // transferToFallback()
    // - _to 주소로 transfer를 사용하여 이더를 보냄
    // - transfer는 2300 가스만 전달 → 대상 컨트랙트의 receive 또는 fallback 함수가 실행됨(단, receive 함수가 있으면 우선)
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    // callFallback()
    // - _to 주소로 call을 사용하여 이더를 보냄
    // - call은 모든 가스를 전달하며, 데이터도 함께 보낼 수 있음
    // - 함수 시그니처 등 데이터가 없으면 receive, 데이터가 있으면 fallback이 실행됨
    // - 이더 전송 성공 여부 확인(실패시 revert)
    function callFallback(address payable _to) public payable {
        (bool sent,) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
