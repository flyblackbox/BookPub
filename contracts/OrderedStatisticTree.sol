pragma solidity ^0.4.15;



library OrderedStatisticTree {
    //function OrderedStatisticTree() {
  //  }
    function update_count(Index storage index,uint value) private {
        Node n=index.nodes[value];
        n.count=1+index.nodes[n.children[false]].count+index.nodes[n.children[true]].count+n.dupes;
    }
    function update_counts(Index storage index,uint value) private {
        uint parent=index.nodes[value].parent;
        while (parent!=0) {
            update_count(index,parent);
            parent=index.nodes[parent].parent;
        }
    }
    function update_height(Index storage index,uint value) private {
        Node n=index.nodes[value];
        uint height_left=index.nodes[n.children[false]].height;
        uint height_right=index.nodes[n.children[true]].height;
        if (height_left>height_right)
            n.height=height_left+1;
        else
            n.height=height_right+1;
    }
    function balance_factor(Index storage index,uint value) constant private returns (int bf) {
        Node n=index.nodes[value];
        return int(index.nodes[n.children[false]].height)-int(index.nodes[n.children[true]].height);
    }
    function rotate(Index storage index,uint value,bool dir) private {
        bool other_dir=!dir;
        Node n=index.nodes[value];
        bool side=n.side;
        uint parent=n.parent;
        uint value_new=n.children[other_dir];
        Node n_new=index.nodes[value_new];
        uint orphan=n_new.children[dir];
        Node p=index.nodes[parent];
        Node o=index.nodes[orphan];
        p.children[side]=value_new;
        n_new.side=side;
        n_new.parent=parent;
        n_new.children[dir]=value;
        n.parent=value_new;
        n.side=dir;
        n.children[other_dir]=orphan;
        o.parent=value;
        o.side=other_dir;
        update_height(index,value);
        update_height(index,value_new);
        update_count(index,value);
        update_count(index,value_new);
    }
    function rebalance_insert(Index storage index,uint n_value) private {
        update_height(index,n_value);
        Node n=index.nodes[n_value];
        uint p_value=n.parent;
        if (p_value!=0) {
            int p_bf=balance_factor(index,p_value);
            bool side=n.side;
            int sign;
            if (side)
                sign=-1;
            else
                sign=1;
            if (p_bf == sign*2) {
                if (balance_factor(index,n_value) == (-1 * sign))
                    rotate(index,n_value,side);
                rotate(index,p_value,!side);
            }
            else if (p_bf != 0)
                rebalance_insert(index,p_value);
        }
    }
    function rebalance_delete(Index storage index,uint p_value,bool side) private{
        if (p_value!=0) {
            update_height(index,p_value);
            int p_bf=balance_factor(index,p_value);
            bool dir=side;
            int sign;
            if (side)
                sign=1;
            else
                sign=-1;
            int bf=balance_factor(index,p_value);
            if (bf==(2*sign)) {
                Node p=index.nodes[p_value];
                uint s_value=p.children[!side];
                int s_bf=balance_factor(index,s_value);
                if (s_bf == (-1 * sign))
                    rotate(index,s_value,!side);
                rotate(index,p_value,side);
                if (s_bf!=0){
                    p=index.nodes[p_value];
                    rebalance_delete(index,p.parent,p.side);
                }
            }
            else if (p_bf != sign){
                p=index.nodes[p_value];
                rebalance_delete(index,p.parent,p.side);
            }
        }
    }
    function fix_parents(Index storage index,uint parent,bool side) private {
        if(parent!=0) {
            update_count(index,parent);
            update_counts(index,parent);
            rebalance_delete(index,parent,side);
        }
    }
    function insert_helper(Index storage index,uint p_value,bool side,uint value) private {
        Node root=index.nodes[p_value];
        uint c_value=root.children[side];
        if (c_value==0){
            root.children[side]=value;
            Node child=index.nodes[value];
            child.parent=p_value;
            child.side=side;
            child.height=1;
            child.count=1;
            update_counts(index,value);
            rebalance_insert(index,value);
        }
        else if (c_value==value){
            index.nodes[c_value].dupes++;
            update_count(index,value);
            update_counts(index,value);
        }
        else{
            bool side_new=(value >= c_value);
            insert_helper(index,c_value,side_new,value);
        }
    }
    function insert(Index storage index,uint value) {
        if (value==0)
            index.nodes[value].dupes++;
        else{
            insert_helper(index,0,true,value);
        }
    }
    function rightmost_leaf(Index storage index,uint value) constant private returns (uint leaf) {
        uint child=index.nodes[value].children[true];
        if (child!=0)
            return rightmost_leaf(index,child);
        else
            return value;
    }
    function zero_out(Index storage index,uint value) private {
        Node n=index.nodes[value];
        n.parent=0;
        n.side=false;
        n.children[false]=0;
        n.children[true]=0;
        n.count=0;
        n.height=0;
        n.dupes=0;
    }
    function remove_branch(Index storage index,uint value,uint left,uint right) private {
        uint ipn=rightmost_leaf(index,left);
        Node i=index.nodes[ipn];
        uint dupes=i.dupes;
        remove_helper(index,ipn);
        Node n=index.nodes[value];
        uint parent=n.parent;
        Node p=index.nodes[parent];
        uint height=n.height;
        bool side=n.side;
        uint count=n.count;
        right=n.children[true];
        left=n.children[false];
        p.children[side]=ipn;
        i.parent=parent;
        i.side=side;
        i.count=count+dupes-n.dupes;
        i.height=height;
        i.dupes=dupes;
        if (left!=0) {
            i.children[false]=left;
            index.nodes[left].parent=ipn;
        }
        if (right!=0) {
            i.children[true]=right;
            index.nodes[right].parent=ipn;
        }
        zero_out(index,value);
        update_counts(index,ipn);
    }
    function remove_helper(Index storage index,uint value) private {
        Node n=index.nodes[value];
        uint parent=n.parent;
        bool side=n.side;
        Node p=index.nodes[parent];
        uint left=n.children[false];
        uint right=n.children[true];
        if ((left == 0) && (right == 0)) {
            p.children[side]=0;
            zero_out(index,value);
            fix_parents(index,parent,side);
        }
        else if ((left !=0) && (right != 0)) {
            remove_branch(index,value,left,right);
        }
        else {
            uint child=left+right;
            Node c=index.nodes[child];
            p.children[side]=child;
            c.parent=parent;
            c.side=side;
            zero_out(index,value);
            fix_parents(index,parent,side);
        }
    }
    function remove(Index storage index,uint value){
        Node n=index.nodes[value];
        if (value==0){
            if (n.dupes==0)
                return;
        }
        else{
            if (n.count==0)
                return;
        }
        if (n.dupes>0) {
            n.dupes--;
            if(value!=0)
                n.count--;
            fix_parents(index,n.parent,n.side);
        }
        else
            remove_helper(index,value);
    }
    function rank(Index storage index,uint value) constant returns (uint smaller){
        if(value!=0){
            smaller=index.nodes[0].dupes;
            uint cur=index.nodes[0].children[true];
            Node cur_node=index.nodes[cur];
            while(true){
                if (cur<=value){
                    if(cur<value)
                        smaller+=1+cur_node.dupes;
                    uint left_child=+cur_node.children[false];
                    if (left_child!=0)
                        smaller+=index.nodes[left_child].count;
                }
                if (cur==value)
                    break;
                cur=cur_node.children[cur<value];
            }
        }
    }
    function select_at(Index storage index,uint pos) constant returns (uint value){
        uint zeroes=index.nodes[0].dupes;
        if (pos<zeroes)
            return 0;
        else {
            uint pos_new=pos-zeroes;
            uint cur=index.nodes[0].children[true];
            Node cur_node=index.nodes[cur];
            while(true){
                uint left=cur_node.children[false];
                uint cur_num=cur_node.dupes+1;
                if (left!=0) {
                    Node left_node=index.nodes[left];
                    uint left_count=left_node.count;
                }
                else {
                    left_count=0;
                }
                if (pos_new<left_count) {
                    cur=left;
                    cur_node=left_node;
                }
                else if (pos_new<left_count+cur_num){
                    return cur;
                }
                else {
                    cur=cur_node.children[true];
                    cur_node=index.nodes[cur];
                    pos_new-=left_count+cur_num;
                }
            }
        }
    }
    function duplicates(Index storage index,uint value) constant returns (uint n){
        return index.nodes[value].dupes+1;
    }
    function count(Index storage index) constant returns (uint count){
        Node root=index.nodes[0];
        Node child=index.nodes[root.children[true]];
        return root.dupes+child.count;
    }
    function in_top_n(Index storage index,uint value,uint n) constant returns (bool truth){
        uint pos=rank(index,value);
        uint num=count(index);
        return (num-pos-1<n);
    }
    function percentile(Index storage index,uint value) constant returns (uint k){
        uint pos=rank(index,value);
        uint same=index.nodes[value].dupes;
        uint num=count( index);
        return (pos*100+(same*100+100)/2)/num;
    }
    function at_percentile(Index storage index,uint percentile) constant returns (uint value){
        uint n=count( index);
        return select_at(index,percentile*n/100);
    }
    function permille(Index storage index,uint value) constant returns (uint k){
        uint pos=rank(index,value);
        uint same=index.nodes[value].dupes;
        uint num=count( index);
        return (pos*1000+(same*1000+1000)/2)/num;
    }
    function at_permille(Index storage index, uint permille) constant returns (uint value){
        uint n=count( index);
        return select_at(index,permille*n/1000);
    }
    function median(Index storage index) constant returns (uint value){
        return at_percentile(index,50);
    }
    function node_left_child(Index storage index,uint value) constant returns (uint child){
        child=index.nodes[value].children[false];
    }
    function node_right_child(Index storage index,uint value) constant returns (uint child){
        child=index.nodes[value].children[true];
    }
    function node_parent(Index storage index,uint value) constant returns (uint parent){
        parent=index.nodes[value].parent;
    }
    function node_side(Index storage index,uint value) constant returns (bool side){
        side=index.nodes[value].side;
    }
    function node_height(Index storage index,uint value) constant returns (uint height){
        height=index.nodes[value].height;
    }
    function node_count(Index storage index,uint value) constant returns (uint count){
        count=index.nodes[value].count;
    }
    function node_dupes(Index storage index, uint value) constant returns (uint dupes){
        dupes=index.nodes[value].dupes;
    }
    struct Node {
        mapping (bool => uint) children; //false left child,true right child
        uint parent;
        bool side;  //side of the tree?
        uint height;
        uint count;
        uint dupes;  //duplicates
    }
    //mapping(uint => Node) nodes;

    struct Index {
            //bytes32 root;
            mapping (uint => Node) nodes;
    }

}
