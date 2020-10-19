<?php session_start(); 
	$pdo = new PDO('mysql:host=localhost;port=3306;dbname=itdaproject','CHW', 'community');
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
if (!isset($_SESSION['staffUsername'])){ //Redirects non-logged in users back to the Login Page
	header('Location: Login.php');
	return;
}


if(isset($_POST['DrugAdm'])){

$sql = "DELETE from chwdrugadministration WHERE AdministrationIdentifier = :AID";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array(
                ':AID' => $_POST['DrugAdm']
              ));
    header('Location: Drug.php');
    return;

}

if(isset($_POST['DrugAdministered'])){


$sql = "INSERT INTO chwdrugadministration (AdministrationIdentifier, CHWTestIdentifier, DrugAdministered, DrugDosageINmg)  VALUES (:AID, :CTI, :DRD, :DDM)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array(
                ':AID' => NULL,
                ':CTI' => $_POST['testID'],
                ':DRD' => $_POST['DrugAdministered'],
                ':DDM' => $_POST['DrugDosageINmg'],
              ));
    header('Location: Drug.php');
    return;

}

?>
<!DOCTYPE html>
<html>
    <head>
    	<link type="text/css" rel="stylesheet" href="Drug.css">
        <title>Drug Administration</title>
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
						<li>
							<a href = "BloodSugarTest.php">Blood Sugar Test</a>
						</li>

						<li style="background-color: #9c0202;">
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

$statement = $pdo->query("SELECT * FROM chwdetaileddrugadministration where StaffIdentifier = ".$_SESSION['StaffID']);

echo '<center><table border="1" style = "text-align:center;">'; 
echo ("<tr><th>AppointmentDate</th><th>AppointmentTime</th><th>PatientName</th><th>PatientSurname</th><th>BloodSugarLevelmmolPerL</th><th>DrugAdministered</th><th>DrugDosageINmg</th><th>Remove<br>Administration<br>Data</th></tr>"); 

while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
       

          echo ('<tr><form method="POST" action = "Drug.php"><td>');
          echo($row['AppointmentDate']);  
		  echo ("</td><td>");
          echo($row['AppointmentTime']);    
          echo("</td><td>");
          echo($row['PatientName']);        
          echo("</td><td>");
          echo($row['PatientSurname']);
          echo("</td><td>");
          echo($row['BloodSugarLevelmmolPerL']);
          echo ("</td><td>");
          echo($row['DrugAdministered']);  
          echo ("</td><td>");
          echo($row['DrugDosageINmg']);  


           echo("</td><td>");
          echo('<input type="submit" value="Remove" id="');
          echo($row['AdministrationIdentifier']);
          echo('" >');
          echo('<input type="hidden" name = "DrugAdm" id = "DrugAdm" value="');
          echo($row['AdministrationIdentifier']);
          echo('" >');


          echo("</td></form></tr>\n");
      }
      echo "</table></center>\n"; 

?>

<br><br><br><center>
			
			<h2>Add New Drug Administration Record:</h2>
			<table border="solid" style = "text-align:center; width:40%; padding: 6px; 
  border-collapse: collapse;">
			<form method="POST" action = "Drug.php">
            <br><tr><td>
            <label for="testID">Test&nbspDetails&nbsp:</label></td><td>
            <select id="testID" name="testID">
<?php

$statement = $pdo->query("SELECT AppointmentDate, AppointmentTime, PatientName, PatientSurname, CHWTestIdentifier, BloodSugarLevelmmolPerL FROM chwdetailedbloodsugarresults where StaffIdentifier = ".$_SESSION['StaffID']);
while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
	echo('<option value = "'.$row['CHWTestIdentifier'].'">'.$row['AppointmentDate']."&nbsp&nbsp&nbsp".$row['AppointmentTime']."&nbsp&nbsp&nbsp".$row['PatientName']." ".$row['PatientSurname'].'&nbsp&nbsp&nbspBlood&nbspSugar&nbspReading&nbsp:&nbsp'.$row['BloodSugarLevelmmolPerL'].'</option>');

}
?>
		</select></td></tr><tr><td>
	            <label for="DrugAdministered">&nbspDrug&nbspAdministered&nbsp:</label></td><td>
	            <input type="DrugAdministered" name="DrugAdministered" id="DrugAdministered"></td></tr><tr><td>
	            <label for="DrugDosageINmg">Drug&nbspDosage<br>[Measured&nbspIn&nbspmg]&nbsp:</label></td><td>
	            <input type="DrugDosageINmg" name="DrugDosageINmg" id="DrugDosageINmg"></td></tr>

			</table><br>
	            
	            <input type="submit" value="submit" id="submit" >
	        </form>
			</table>
</center>

    </body>
    <footer>
    	
    </footer>
</html>



