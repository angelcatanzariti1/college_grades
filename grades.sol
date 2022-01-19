// SPDX-License-Identifier: MIT
pragma solidity >0.4.0 <=0.7.0;
pragma experimental ABIEncoderV2;

contract grades{

    // DECLARATIONS ---------------------------------------------------
    
    // professor address declaration
    address public professor;

    // constructor
    constructor() public{
        professor = msg.sender;
    }

    // relation between students and grades
    mapping (bytes32 => uint) Grades;

    // exam revision requests
    string[] revisions;

    // events
    event student_graded(bytes32, uint);
    event exam_revision(string);


    // GRADE STUDENTS ------------------------------------------------

    modifier OnlyProfessor(address _address){
        // only the contract owner can grade
        require(msg.sender == professor, "Permission denied");
        _;
    }
    

    function Grade(string memory _idStudent, uint _grade) public OnlyProfessor(msg.sender){
        // student ID hash
        bytes32 hash_idStudent = keccak256(abi.encodePacked(_idStudent));

        // id => grades
        Grades[hash_idStudent] = _grade;

        // trigger event
        emit student_graded(hash_idStudent, _grade);
    }

    // VIEW STUDENTS' GRADES -----------------------------------------
    function ViewGrades(string memory _idStudent) public view returns(uint){
        // student ID hash
        bytes32 hash_idStudent = keccak256(abi.encodePacked(_idStudent));
        return Grades[hash_idStudent];
    }

    // EXAM REVISION REQUEST ------------------------------------------
    function Revision(string memory _idStudent) public {
        // ID needs to be readable, not hash
        revisions.push(_idStudent);
        emit exam_revision(_idStudent);
    }


}