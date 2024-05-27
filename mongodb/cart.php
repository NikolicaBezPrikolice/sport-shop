<?php
require_once "header.php";

if (isset($_GET['remove'])){
   $delete=$db->cart->deleteMany(array('buyer'=>$user));
}

if (isset($_GET['order'])){
    $res=$db->users->findOne(array('username'=>$user));
    if($res->count()){
        $time = time();
        $result=$db->cart->find(array('buyer'=>$user));
        $itr = new IteratorIterator($result);
        $itr -> rewind();
        while($result = $itr->current()){
            $result1=$db->products->findOne(array('pname'=>$result->product));
            $insert=$db->orders->insertOne(array('buyer'=>$user, 'product'=>$result->product, 'amount'=>$result->amount, 'cost'=>$result->cost, 'time'=>$time));
            $update=$db->products->UpdateOne(['pname'=>$result->product],
                ['$set'=>['pstock'=>$result1->pstock-$result->amount]]);
            $itr->next();
        }
        $delete=$db->cart->deleteMany(array('buyer'=>$user));
    } else {
        echo "<div class='check'>Da biste uspesno narucili knjigu neophodno je da unesete bitne informacije vezane za dostavu knjige!</div>" . "<a id='ord' href=profile.php>Unesi podatke</a>";
    }
}

?>
<div class="content">       
    <?php
        $kproducts = false;
        $result=$db->cart->find(array('buyer'=>$user));
        $itr = new IteratorIterator($result);
        $itr -> rewind();
        echo "<table style='width:100%' border='1px solid black'>";
        $total=0;
        while($result = $itr->current()){    
            echo "<tr>";
            echo "<td>";
            echo "Naziv: ".$result->product;
            echo "</td>";
            echo "<td>";
            echo "Kolicina: ".$result->amount;
            echo "</td>";
            echo "<td>";
            echo "Cena: ".$result->cost;
            echo "</td>";
            echo "</tr>" ;
            $total=$total+$result->cost;

            $kproducts = true;
            $itr->next();
        }
            echo "</table>";
        if($kproducts){
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
        if($kproducts == FALSE){
            echo "<div><h2>Vaša korpa je prazna</h2></div>";
            echo "<div class='dknjige'><a href='indexsql.php'>Naruci</div>";        
        }
    ?>
  </div>