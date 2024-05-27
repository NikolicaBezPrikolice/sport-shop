<?php
    require_once 'header.php';
    if(!$loggedin){
        die("<h3>Morate biti <a href='login.php'>prijavljeni<a> da biste videli stranicu</h3></div></body></html>");
    }
    $name=$email=$phone=$address=$place="";
    $nameError=$emailError=$phoneError=$addressError=$placeError="";

    $result=$db->users->findOne(array('_id'=>$id));

    $rowsCount=$result->count();
    if($rowsCount>3){
        $name=$result->name;
        $email=$result->email;
        $phone=$result->phone;
        $address=$result->address;
        $place=$result->place;
    }

    if($_SERVER['REQUEST_METHOD']=="POST"){
        
        if(!empty($_POST['name'])){
            $name=$_POST['name'];
        }
        else{
            $nameError="Morate uneti vaše ime i prezime!";
        }
        if(empty($_POST['email'])){
            $emailError="Morate uneti vaš email!";
        }
        else{
            $email=$_POST['email'];

            if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
                $emailError="Format email-a nije ispravan";
                $email="";
            }
        }
        if(!empty($_POST['phone'])){
            $phone=$_POST['phone'];
        }
        else{
            $phoneError="Morate uneti vaš broj telefona!";
        }
        if(!empty($_POST['address'])){
            $address=$_POST['address'];
        }
        else{
            $addressError="Morate uneti vašu adresu";
        }
        if(!empty($_POST['place'])){
            $place=$_POST['place'];
        }
        else{
            $placeError="Morate uneti mesto prebivalista!";
        }
        if($nameError=="" && $emailError=="" && $phoneError=="" && $addressError=="" && $placeError==""){
            if($result){
                $result=$db->users->updateOne(['_id'=>$id],
                    ['$set'=>['name'=>$name, 'email'=>$email, 'phone'=>$phone, 'address'=>$address, 'place'=>$place]]);
            }
        }

    }
?>
<div class="content">
    <h2>
        Popunite vaš profil
    </h2>
    <span class="error"></span>
    <br>
    <br>
    <form action="" method="POST">
        <label for="name">Ime i prezime</label><br>
        <input type="text" name="name" id="name" value="<?php echo $name ?>">
        <span class="error">* <?php echo $nameError ?></span>
        <br>
        <label for="email">Email</label><br>
        <input type="text" name="email" id="email" value="<?php echo $email ?>">
        <span class="error">* <?php echo $emailError ?></span>
        <br>
        <label for="phone">Broj telefona</label><br>
        <input type="text" name="phone" id="phone" value="<?php echo $phone ?>">
        <span class="error">* <?php echo $phoneError ?></span>
        <br>
        <label for="address">Adresa</label><br>
        <input type="text" name="address" id="address" value="<?php echo $address ?>">
        <span class="error">* <?php echo $addressError ?></span>
        <br>
        <label for="Place">Mesto</label><br>
        <input type="text" name="place" id="place" value="<?php echo $place ?>">
        <span class="error">* <?php echo $placeError ?></span>
        <br>
        <input id="submit" type="submit" value="Sacuvaj podatke">
    </form>
    
    </div>

</div>
</body>
</html>