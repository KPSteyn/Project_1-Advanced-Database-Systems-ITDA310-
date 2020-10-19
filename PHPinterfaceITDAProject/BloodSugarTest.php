<?php session_start(); 
	$pdo = new PDO('mysql:host=localhost;port=3306;dbname=itdaproject','CHW', 'community');
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
if (!isset($_SESSION['staffUsername'])){ //Redirects non-logged in users back to the Login Page
	header('Location: Login.php');
	return;
}



if(isset($_POST['TesID'])){

$sql = "DELETE from chwtest where CHWTestIdentifier = :TID";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array(
                ':TID' => $_POST['TesID']
              ));
    header('Location: BloodSugarTest.php');
    return;

}


if(isset($_POST['appointmentID'])){


$sql = "INSERT INTO chwtest (CHWTestIdentifier, AppointmentIdentifier, BloodSugarLevelmmolPerL)  VALUES (:TID, :AID, :BSL)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array(
                ':TID' => NULL,
                ':AID' => $_POST['appointmentID'],
                ':BSL' => $_POST['BloodSugarLevel'],
              ));
    header('Location: BloodSugarTest.php');
    return;

}

?>
<!DOCTYPE html>
<html>
    <head>
    	<link type="text/css" rel="stylesheet" href="Drug.css">
        <title>Blood Sugar Tests</title>
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
						<li>
							<a href = "Patient.php">Patients</a>
						</li>
						<li>
							<a href = "Schedule.php">Schedule</a>
						</li>
						<li style="background-color: #9c0202;">
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
    <body>
    	<br><br><br><br><br>
    	<?php 
$todayDate = date("Y-m-d");
$rowFormat;

$statement = $pdo->query("SELECT * FROM chwdetailedbloodsugarresults where StaffIdentifier = ".$_SESSION['StaffID']);

echo '<center><table border="1" style = "text-align:center;">'; 
echo ("<tr><th>Patient Name</th><th>Patient Surname</th><th>Appointment Date</th><th>Appointment Time</th><th>Blood Sugar Level<br>mmol/L</th><th>Remove<br>Test<br>Data</th></tr>"); 

while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
       

          echo ('<tr><form method="POST" action = "BloodSugarTest.php"><td>');
          echo($row['PatientName']);  
		  echo ("</td><td>");
          echo($row['PatientSurname']);    
          echo("</td><td>");
          echo($row['AppointmentDate']);        
          echo("</td><td>");
          echo($row['AppointmentTime']);
          echo("</td><td>");
          echo($row['BloodSugarLevelmmolPerL']);

           echo("</td><td>");
          echo('<input type="submit" value="Remove" id="');
          echo($row['CHWTestIdentifier']);
          echo('" >');
          echo('<input type="hidden" name = "TesID" id = "TesID" value="');
          echo($row['CHWTestIdentifier']);
          echo('" >');

          echo("</td></form></tr>\n");
      }
      echo "</table></center>\n"; 

?>

<br><br><br><center>
			<h2>Add new Test Results:</h2>

			<table border="solid" style = "text-align:center; width:40%; padding: 6px; 
  border-collapse: collapse;">
			<form method="POST" action = "BloodSugarTest.php">
            <br><tr><td>
            <label for="appointmentID">Test&nbspDetails&nbsp:</label></td><td>
            <select id="appointmentID" name="appointmentID">
<?php

$statement = $pdo->query("SELECT AppointmentDate, AppointmentTime, PatientName, PatientSurname, AppointmentIdentifier FROM chwstaffviewappointment where StaffIdentifier = ".$_SESSION['StaffID']);
while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
	echo('<option value = "'.$row['AppointmentIdentifier'].'">'.$row['AppointmentDate']."&nbsp&nbsp&nbsp".$row['AppointmentTime']."&nbsp&nbsp&nbsp".$row['PatientName']." ".$row['PatientSurname'].'</option>');

}
?>
		</select></td></tr><tr><td>
	            <label for="BloodSugarLevel">Test&nbspReading<br>[Blood&nbspSugar&nbspLevel&nbsp(mmol/L)]&nbsp:</label></td><td>
	            <input type="BloodSugarLevel" name="BloodSugarLevel" id="BloodSugarLevel"></td></tr>
	            
			</table><br>
	            <input type="submit" value="submit" id="submit" >
	        </form>
			</table>
</center>

    </body>
    <footer>
    	
    </footer>
</html>



