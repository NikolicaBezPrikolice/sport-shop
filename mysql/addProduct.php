<?php
    require_once 'header.php';
    if (!$loggedin){
        header("Location: login.php");
    }
    $pname = $ptype = $pamount = $pprice = $pdesc = "";
    $pnameError = $ptypeError = $pamountError  = $ppriceError = $pdescError = $pimageError = "";

    if($_SERVER['REQUEST_METHOD'] == "POST"){

        if(!empty($_POST['pname'])){
            $pname = sanitizeString($_POST['pname']);
        } else {
            $pnameError = "Unesite naziv artikla!";
        }
        if(!empty($_POST['ptype'])){
            $ptype = sanitizeString($_POST['ptype']);
            if($ptype=="obuca"){
                $ptype=1;
            }
            elseif($ptype=="odeca"){
                $ptype=2;
            }
            elseif($ptype=="oprema"){
                $ptype=3;
            }
        } else {
            $ptypeError = "Unesite tip artikla!";
        }
        if(!empty($_POST['pdesc'])){
            $pdesc = sanitizeString($_POST['pdesc']);
        } else {
            $pdescError = "Unesite opis vozila!";
        }
        
        if ($pnameError == ""  && $ptypeError == "" && $pamountError == "" && $ppriceError =="" && $pdescError ==""){
                queryMysql("CALL dodaj_artikal('$pname', '$pdesc', '$ptype')");
           echo "<p class='tic'>Artikal je uspesno dodan!</p>";
        }  
    }

    if(isset($_FILES['pimage']['name']) && !empty($_FILES['pimage']['name'])){
        if(!file_exists('slike/')){
            mkdir('slike/', 0777, true);
        }

        $saveto="slike/p$pname.jpg";
        move_uploaded_file($_FILES['pimage']['tmp_name'],$saveto);
    
        $typeok=true;
        switch($_FILES['pimage']['type']){
            case "image/gif":
                $src=imagecreatefromgif($saveto);
                break;
            case "image/jpeg":
            case "image/jpg":
                $src=imagecreatefromjpeg($saveto);
                break;
            case "image/png":
                $src=imagecreatefrompng($saveto);
                break;
            default:
            $typeok=false;
        }
        if(!$typeok){
            $pimageError="Dozvoljeni formati slike: gif/jpeg/jpg/png!";
        }
        else{
            list($w, $h)=getimagesize($saveto);

            $max=400;
            $tw=$w;
            $th=$h;
            if($w>$h && $w> $max){
                $th=$max*$h/$w;
                $tw=$max;
            }
            elseif($th>$tw && $h>$max){
                $tw=$max*$w/$h;
                $th=$max;
            }
            else{
                $th=$tw=$max;
            }
            $tmp=imagecreatetruecolor($tw,$th);
            imagecopyresampled($tmp, $src, 0, 0, 0, 0, $tw, $th, $w, $h);
            imageconvolution($tmp, array(array(-1, -1, -1), array(-1, 16, -1),
                array(-1, -1, -1)), 8, 0);
            imagejpeg($tmp, $saveto);
            imagedestroy($tmp);
        }
    }

?>

<div class="content">
    
    <form action="" method = "POST" enctype="multipart/form-data">
        <label for="pname">Naziv artikla:</label><br>
        <input type="text" name="pname" id="pname" value= "<?php echo $pname ?>">
        <span class="error"><?php echo $pnameError; ?></span><br>
        <label for="ptype">Tip artikla:</label><br>
        <select name="ptype" id="ptype">
            <option value="" <?php echo ($ptype == "") ? "selected" : "" ?>>--Odaberi--</option>
            <option value="obuca" <?php echo ($ptype == "obuca") ? "selected" : "" ?>>Obuca</option>
            <option value="odeca" <?php echo ($ptype == "odeca") ? "selected" : "" ?>>Odeca</option>
            <option value="oprema" <?php echo ($ptype == "oprema") ? "selected" : "" ?>>Oprema</option>
        </select>
        <span class="error"><?php echo $ptypeError ?></span><br>
        <label for="pdesc">Opis:</label><br>
        <textarea name="pdesc" id="pdesc" cols="30" rows="4"><?php echo $pdesc?></textarea>
        <span class="error"><?php echo $pdescError; ?></span><br>
        <label for="pimage">Slika :</label>
        <input type="file" name="pimage" id="pimage">
        <span class="error"><?php echo $pimageError; ?></span><br>
        <input id="submit" type="submit" value="Dodaj artikal">
    
    </form>

    </div>

</div>
</body>
</html>