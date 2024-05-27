<?php
require_once "header.php";

if (isset($_GET['remove'])){
    queryMysql("CALL brisi_korpu($id)");
    while(mysqli_next_result($connection)){;} 
}

if (isset($_GET['order'])){
    
    $p = queryMysql("CALL podaci_profil($id)");
    while(mysqli_next_result($connection)){;}
    if($p->num_rows){
        $time = time();
        $result = queryMysql("CALL podaci_korpa($id)");
        while(mysqli_next_result($connection)){;}
        while($row=$result->fetch_assoc()){
            $amount=$row['amount'];
            $produktId=$row['product_id'];
            $sumPrice=$row['sum_price'];
            queryMysql("CALL upis_orders($id, $produktId, $amount,$sumPrice ,$time)");
            while(mysqli_next_result($connection)){;}
        }
        queryMysql("CALL brisi_korpu($id)");
        while(mysqli_next_result($connection)){;} 
    } else {
        echo "<div class='check'>Da biste uspesno narucili knjigu neophodno je da unesete bitne informacije vezane za dostavu knjige!</div>" . "<a id='ord' href=profile.php>Unesi podatke</a>";
    }
}
?>
<div class="content">       
    <?php
        $kbooks = false;
        $result = queryMysql("CALL podaci_korpa($id)");
        while(mysqli_next_result($connection)){;}
        $result1=queryMysql("CALL podaci_profil($id)");
        while(mysqli_next_result($connection)){;}
        if($result1->num_rows>0){
            $row=$result1->fetch_assoc();
            if($row['discount']){
                $discount=$row['discount'];
            }
            else{
                $discount=0;
            }
        }
        echo "<table style='width:100%' border='1px solid black'>";
            while($row = $result->fetch_assoc()){
                showProduct($row['product_id'],$id);
                $kbooks = true;
            }
            $total=$total/100*(100-$discount);
            echo "</table>";
        if($kbooks){
            echo "<ul>";
            echo "Ukupna cena: $total";
            echo "<br>";
            echo "<a id='ord' href='cart.php?order'>Naruči</a>";
            echo "<br>";
            echo "<br>";
            echo "<a id='ord' href='cart.php?remove'>Ocisti korpu</a>";
            echo "<br>";
            echo "</li>";
        echo "</ul>";
        }
        if($kbooks == FALSE){
            echo "<div><h2>Vaša korpa je prazna</h2></div>";
            echo "<div class='dknjige'><a href='indexsql.php'>Naruci</div>";        
        }
    ?>
  </div>