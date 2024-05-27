<?php
require_once 'header.php';
if(!$loggedin){
    die("</div></body></html>");
}


if(isset($_GET['delete'])){
    $messageId=$_GET['delete'];
   $delete=$db->messages->deleteOne(array('_id'=>new MongoDB\BSON\ObjectId("$messageId")));
}

$result=$db->messages->find(array('receiver'=>$user));

foreach($result as $res){
    echo "<div class='message'>";
    echo $res->time;
    $messageId=$res->_id;
    echo "   ".$res->sender;
    echo "<br><br>&quot;". $res->message ."&quot;";
    echo "<br><br><a href='messages.php?delete=$messageId'>Izbrisi poruku</a>";
    echo "</div>";
}