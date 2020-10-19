<?php
	session_start();
	$_SESSION['errorCode'] = "";
	$pdo = new PDO('mysql:host=localhost;port=3306;dbname=itdaproject','CHW', 'community');
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	if(isset($_POST['staffUsername'])){
		$statement = $pdo->prepare(
	       'SELECT StaffUsername, StaffPassword, StaffIdentifier FROM chwstafflogindetails WHERE StaffUsername = :userName AND StaffPassword = :userPassword'
	    );
  		$statement->execute(array( 
	       ':userName' => $_POST['staffUsername'], ':userPassword' => $_POST['staffPassword']
	    ));
	    $resultRow = $statement->fetch(PDO::FETCH_ASSOC);
 		if ( $resultRow === false ) { 
 			$_SESSION['errorCode'] = "<br><br><strong><span style = \"color:red\";>Invalid Login Information Submitted.<br>Username Submitted:".$_POST['staffUsername']."<br>Password Submitted:".$_POST['staffPassword']."</span></strong><br><br>";
 		}else{
 			$_SESSION['staffUsername'] = $_POST['staffUsername'];
 			$_SESSION['StaffID'] = $resultRow['StaffIdentifier'];
	    	header( 'Location: Home.php') ;
	    	return;
	    }
	}
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Basic Login Page</title>
    </head>
    <body>
    	<br>
    	<center>
    		<h2>Welcome to the BroadReach CHW System</h2>
	        <form method="POST">
            <br>
	            <label for="staffUsername">Staff&nbspUsername&nbsp:</label>
	            <input type="text" name="staffUsername" id="staffUsername"><br><br>
	            <label for="staffPassword">Staff&nbspPassword&nbsp:</label>
	            <input type="password" name="staffPassword" id="staffPassword"><br><br>
	            <input type="submit" value="Validate Login" id="submit" ><br>
	        </form>
	        <?php 
	        	echo($_SESSION['errorCode']);
	        ?>
	        </center>
    </body>
</html>




