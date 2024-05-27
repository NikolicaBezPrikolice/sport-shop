<?php
$dbhost="localhost";
$dbname="sqldb";
$dbuser="myadmin";
$dbpassword="123";

$connection= new mysqli($dbhost, $dbuser, $dbpassword, $dbname);
if($connection->connect_error !=null){
    die("$connection->connect_error");
}

function queryMysql($query){
    global $connection;
    $result=$connection->query($query);
    if(!$result){
        die($connection->error);
    }
    return $result;
}

function createTable($name, $query){
    queryMysql("CREATE TABLE IF NOT EXISTS $name($query)");
    echo "Table '$name' created or alreadt exists.<br>";
}


function sanitizeString($text){
    $text=strip_tags($text);
    $text=htmlentities($text);
    $text=stripslashes($text);
    global $connection;
    $text=$connection->real_escape_string($text);
    return $text;
}

function showProfile($id)
{
    global $connection;
    $result=queryMysql("CALL podaci_profil($id)");
    while(mysqli_next_result($connection)){;}
    $result1=queryMysql("SELECT potrosio($id)");
    while(mysqli_next_result($connection)){;}
    if($result->num_rows)
    {
        $row=$result->fetch_assoc();
        $result1=$result1->fetch_assoc();
        echo"<div class='profile'>";
        echo $row['name'];
        echo"<br>";
        echo $row['email'];
        echo "<br>";
        echo $row['phone'];
        echo "<br>";
        echo $row['address'];
        echo "<br>";
        echo $row['place'];
        echo "<br>";
        echo "Ukupno potrosio: ".implode($result1)." dinara";
        echo "</div>";
    }
}

function showProducts(){
    $ok=false;
    if(isset($_SESSION['username'])){
        $user=PrivilegedUser::getByUsername($_SESSION['username']);
        if($user !== false && $user->hasPrivilege("Run SQL")){
            $ok=true;
        }
    }   
    $result=queryMysql("SELECT * FROM products");
    if($result->num_rows){
        while($row=$result->fetch_assoc()){
            $productName=$row['name'];
            $productId=$row['id'];
            echo "<div class='veh'>";
            echo "<a href='indexsql.php?show=$productName'>";
            if(file_exists("slike/p$productName.jpg")){
                echo"<img src='slike/p$productName.jpg' class='pf'>";
            }
            echo "</a>";
            echo "<div class='vehw'>";
            echo "<span class='name'>" .$row['name']."</span>";
            echo "<br>";
            if($row['stock']>0){
                echo "<span class='price'>" .$row['price']." rsd"."</span>";
            }
            else{
                echo "<span class='price'>" ."Rasprodato"."</span>";
            }
            echo "<br>";
            if($ok){
            echo "<span class='name'>"."Na stanju: " .$row['stock']."</span>";
            echo "<br>";
            echo "<br>";
            echo "<a class='remove' href='indexsql.php?show=$productName#dopuni'>Dopuni stanje</a>";
            echo "<br>";
            echo "<a class='remove' href='indexsql.php?remove=$productId'>Izbriši artikal</a>";
            }
            echo "</div>";
            echo "</div>";
        }
    }
    else{
        echo "<p> You still don't have products. Add one.</p>";
    }

}
$total=0;
function showProduct($pId,$id){
    $result = queryMysql("SELECT * FROM products
                        INNER JOIN cart ON products.id=cart.product_id
                        INNER JOIN profiles ON cart.buyer_id=profiles.user_id
                         WHERE products.id = $pId and cart.buyer_id=$id");
    if($result->num_rows){
        $row = $result->fetch_assoc();
        echo "<tr>";
        echo "<td>";
        echo "Naziv: ".$row['name'];
        echo "</td>";
        echo "<td>";
        echo "Kolicina: ".$row['amount'];
        echo "</td>";
        echo "<td>";
        echo "Cena: ".$row['price']*$row['amount']/100*(100-$row['discount']);
        echo "</td>";
        echo "</tr>" ;
        global $total;
        $total=$total+$row['price']*$row['amount'];
    }
  

}

