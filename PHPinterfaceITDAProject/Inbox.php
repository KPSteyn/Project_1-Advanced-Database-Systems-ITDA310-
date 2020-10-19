<?php session_start(); 
	$pdo = new PDO('mysql:host=localhost;port=3306;dbname=itdaproject','CHW', 'community');
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
if (!isset($_SESSION['staffUsername'])){ //Redirects non-logged in users back to the Login Page
	header('Location: Login.php');
	return;
}
?>
<!DOCTYPE html>
<html>
    <head>
    	<link type="text/css" rel="stylesheet" href="Inbox.css">
        <title>Inbox</title>
        <header> 
				<nav>
					<ul>
						<li id="homenav">
							<a href = "Home.php">HOME</a>
						</li>
						<li>
							<a href = "Household.php">Patient's Household Members</a>
						</li>
						<li style="background-color: #9c0202;">
							<a href = "Inbox.php">Inbox</a>
						</li>
						<li>
							<a href = "video.php">Videos</a>
						</li>
						<li>
							<a href = "Patient.php">Patients</a>
						</li>
						<li>
							<a href = "Schedule.php">Schedule</a>
						</li>
						<li>
							<a href = "BloodSugarTest.php">Blood Sugar Test</a>
						</li>
						<li>
							<a href = "Drug.php">Drug Administration</a>
						</li>
						<li>
							<a href = "LogOutCHW.php">Logout</a>
						</li>
					</ul>
				</nav>

			</header>

    </head>
   <br><br><br><br><br>
    	
<?php 

$statement = $pdo->prepare("SELECT MessageContent, MessageIdentifier FROM message  WHERE StaffMessageRecipient = :staffID ORDER BY MessageIdentifier DESC;");


  		$statement->execute(array( 
	       ':staffID' => $_SESSION['StaffID'],
	    ));




echo '<center><table border="1" style = "text-align:center">'; 
echo ("<tr><th>Inbox</th></tr>"); 

while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
	
          echo "<tr><td>";

          echo($row['MessageContent']);
          
          echo("</td></tr>\n");
      }
      echo "</table></center>\n"; 



?>


    </body>
    <footer>
    	
    </footer>
</html>



