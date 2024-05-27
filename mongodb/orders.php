<?php
require_once "header.php";
if (!$loggedin){
    header("Location: login.php");
}
?>

<div class="content">       
    <?php
        $kproducts = false;
        $result =$db->orders->find(array('buyer'=>$user));
        echo "<h3>Istorija narudzbina:</h3>";
        echo "<table style='width:100%' border='1px solid black'>";
            foreach($result as $row){
                echo "<tr>";
                echo "<td>";
                echo "Naziv: ".$row->product;
                echo "</td>";
                echo "<td>";
                echo "Kolicina: ".$row->amount;
                echo "</td>";
                echo "<td>";
                echo "Placeno: ".$row->cost;
                echo "</td>";
                echo "<td>";
                echo "Datum: ".date("j.n.Y. H:i:s: ",$row->time);
                echo "</td>";
                echo "</tr>" ;
                $kproducts = true;
            }
            echo "</table>";
        if($kproducts == FALSE){
            echo "<div><h2>Nemate narudzbina</h2></div>";
            echo "<div class='dknjige'><a href='indexsql.php'>Naruci</div>";        
        }
    ?>
  </div>