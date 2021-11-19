pragma solidity >=0.7.0 <0.9.0;


contract Storage {
    
    struct User{
     uint userid;
     string username;
     mapping(uint => uint) JointAcc;
 }
 
 struct Joint{
     uint user_id_1;
     uint user_id_2;
     uint user_id_1_bal;
     uint user_id_2_bal;
     
 }
  
 uint acc_num=0;
 mapping(uint=>Joint) JointAccList;
 mapping(uint => User) users;
 mapping(uint => uint[]) adjmatrix;
 uint joint_num=0;
 uint[] visited;
 uint[] new_path;
 uint[]  path;
 uint[][] queue;
 constructor(){
    
 }
function registerUser(uint _user_id, string memory _user_name) public {
      
     User storage u = users[_user_id];
     u.userid=_user_id;
     u.username=_user_name;
 }


function createAcc(uint _user_id_1, uint _user_id_2,uint bal1,uint bal2) public returns (uint account_){
    JointAccList[acc_num]= Joint(_user_id_1,_user_id_2,bal1,bal2);
    users[_user_id_1].JointAcc[_user_id_2]= acc_num;
    users[_user_id_2].JointAcc[_user_id_1]= acc_num;
    adjmatrix[_user_id_1].push(_user_id_2);
    adjmatrix[_user_id_2].push(_user_id_1);
    account_=acc_num;
    acc_num+=1;
    
    
}


function sender(uint _user_id_1,uint _user_id_2,uint amount) internal{
    
    uint num=users[_user_id_1].JointAcc[_user_id_2];
    JointAccList[num].user_id_1_bal-=amount;
    JointAccList[num].user_id_2_bal+=amount;
    
    
}
function verifybalance(uint _user_id_1,uint _user_id_2,uint amount) internal view returns (bool status){
    
    uint num=users[_user_id_1].JointAcc[_user_id_2];
    if(JointAccList[num].user_id_1_bal>=amount){
        status = true;
    }
    else{
        status = false;
    }
    
    
    
}

function checkbalancebyaccnum(uint num) public view returns (uint balance_)
{
    balance_ = JointAccList[num].user_id_1_bal+JointAccList[num].user_id_2_bal;
}
function checkbalancebyuserid(uint _user_id_1,uint _user_id_2) public view returns (uint balance_)
{
    uint num=users[_user_id_1].JointAcc[_user_id_2];
    balance_ = JointAccList[num].user_id_1_bal+JointAccList[num].user_id_2_bal;
}

function sendAmount(uint _user_id_1, uint _user_id_2,uint amount)public{
    
    queue.push([_user_id_1]);
    uint last=0;
    uint first=0;
    uint vertex;
    bool visit_status;
    bool found=false;
    bool status;
    
    while (first<=last){
        
        delete path;
        path=queue[first];
        delete queue[first];
        first+=1;
        vertex = path[path.length-1];
        if(vertex==_user_id_2)
        {
            found=true;
            break;
        }
        visit_status=false;
        
        for (uint i=0; i < visited.length; i++) {
        if (vertex == visited[i]) {
            visit_status=true;
            break;
        }
        }
        if (visit_status==false){
        for(uint i=0;i<adjmatrix[vertex].length;i++){
            new_path=path;
            new_path.push(adjmatrix[vertex][i]);
            status=verifybalance(vertex,adjmatrix[vertex][i],amount);
            if (status==true){
            queue.push(new_path);
            last+=1;
            }
            
            delete new_path;
        }
        visited.push(vertex);
        }
        delete path;
    }
    delete visited;
    delete queue;
    if (found==true){
    for(uint i=0;i<path.length;i++){
        
        sender(path[i],path[i+1],amount);
        
    }
    }
    delete path;
    
}
function closeAccount(uint _user_id_1, uint _user_id_2) public{
    
    uint num=users[_user_id_1].JointAcc[_user_id_2];
    delete JointAccList[num];
}


}

