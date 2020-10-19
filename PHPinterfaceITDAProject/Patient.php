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
    	<link type="text/css" rel="stylesheet" href="Patient.css">
        <title>Patients</title>
        <header> 
				<nav>
					<ul>
						<li id="homenav">
							<a href = "Home.php">HOME</a>
						</li>
						<li>
							<a href = "Household.php">Patient's Household Members</a>
						</li>
						<li>
							<a href = "Inbox.php">Inbox</a>
						</li>
						<li>
							<a href = "video.php">Videos</a>
						</li>
						<li style="background-color: #9c0202;">
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

$statement = $pdo->query("SELECT * FROM chwdetailedpatientassignment WHERE StaffIdentifier = ".$_SESSION['StaffID']);


echo '<center><table border="1" style = "text-align:center">'; 
echo ("<tr><th>PatientName</th><th>PatientSurname</th><th>Address</th><th>PhoneNumber</th><th>EmailAddress</th><th>Age</th><th>Gender</th></tr>"); 

while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
        //The $row variable will represent a new [Key]->Value array each time an itteration occurs across the educationalvideo table until there isn't a [Key]->Value array left to assign to $row 
          echo "<tr><td>";
          echo($row['PatientName']);
          echo "</td><td>";
          echo($row['PatientSurname']);
          echo "</td><td>";
          echo($row['Address']);
          echo "</td><td>";
          echo($row['PhoneNumber']);
          echo "</td><td>";
          echo($row['EmailAddress']);
          echo "</td><td>";
          echo($row['Age']);
          echo "</td><td>";
          echo($row['Gender']);
          echo("</td></tr>\n");
      }
      echo "</table></center>\n"; 



?>


    </body>
    <footer>
    	
    </footer>
</html>



