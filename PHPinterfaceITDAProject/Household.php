<?php session_start(); 
  $pdo = new PDO('mysql:host=localhost;port=3306;dbname=itdaproject','CHW', 'community');
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

if (!isset($_SESSION['staffUsername'])){ //Redirects non-logged in users back to the Login Page
	header('Location: Login.php');
	return;
}



if(isset($_POST['HMIdent'])){


$sql = "DELETE from householdmember WHERE HMIdentifier = :HMI";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array(
                ':HMI' => $_POST['HMIdent']
              ));
  header('Location: Household.php');
    return;

}


if(isset($_POST['patientID'])){


$sql = "INSERT INTO householdmember (HMIdentifier, PatientIdentifier, MemberName, MemberSurname, CellphoneNumber, EmailAddress, ExistingMedicalConditions, RelationshipWithPatient)  VALUES (:HMI, :PID, :MNA, :MSU, :CPN, :EA, :EMC, :RWP)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array(
                ':HMI' => NULL,
                ':PID' => $_POST['patientID'],
                ':MNA' => $_POST['MemberName'],
                ':MSU' => $_POST['MemberSurname'],
                ':CPN' => $_POST['CellphoneNumber'],
                ':EA' => $_POST['EmailAddress'],
                ':EMC' => $_POST['ExistingMedicalConditions'],
                ':RWP' => $_POST['RelationshipWithPatient'],
              ));
  header('Location: Household.php');
    return;

}


if(isset($_POST['memberID'])){


$sql = "UPDATE householdmember SET MemberName = :MNA, MemberSurname = :MSU, CellphoneNumber = :CPN, EmailAddress = :EA, ExistingMedicalConditions = :EMC, RelationshipWithPatient = :RWP WHERE HMIdentifier = :HMI";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array(
                ':HMI' => $_POST['memberID'],
                ':MNA' => $_POST['NewMemberName'],
                ':MSU' => $_POST['NewMemberSurname'],
                ':CPN' => $_POST['NewCellphoneNumber'],
                ':EA' =>  $_POST['NewEmailAddress'],
                ':EMC' => $_POST['NewExistingMedicalConditions'],
                ':RWP' => $_POST['NewRelationshipWithPatient'],
              ));
  header('Location: Household.php');
    return;

}


?>
<!DOCTYPE html>
<html>
    <head>
    	<link type="text/css" rel="stylesheet" href="Household.css">
        <title>Patient's Household Members</title>
        <header> 
				<nav>
					<ul>
						<li id="homenav">
							<a href = "Home.php">HOME</a>
						</li>
						<li style="background-color: #9c0202;">
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
$statement = $pdo->query("SELECT * FROM chwstaffviewhouseholdmembers where StaffIdentifier = ".$_SESSION['StaffID']);
echo '<center><table border="1" style = "text-align:center;">'; 
echo ("<tr><th>Address</th><th>PatientID</th><th>Patient<br>Name</th><th>Patient<br>Surname</th><th>Patient<br>Phone Number</th><th>Patient<br>Email</th><th>Relationship<br>With Patient</th><th>Member<br>Name</th><th>Member<br>Surname</th><th>Member<br>Phone Number</th><th>Member<br>Email Address</th><th>Member's Existing<br>Medical Conditions</th><th>Remove<br>Household<br>Member</th></tr>"); 

while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
          echo ('<tr><form method="POST" action = "Household.php"><td>');
          echo($row['Address']);  
		      echo ("</td><td>");
          echo($row['PatientIdentifier']);    
          echo("</td><td>");
          echo($row['PatientName']);        
          echo("</td><td>");
          echo($row['PatientSurname']);
          echo("</td><td>");
          echo($row['patientPhoneNumber']);
          echo("</td><td>");
          echo($row['patientEmailAddress']);
          echo("</td><td>");
          echo($row['RelationshipWithPatient']);
          echo("</td><td>");
          echo($row['MemberName']);
          echo("</td><td>");
          echo($row['MemberSurname']);
          echo("</td><td>");
          echo($row['householdMemberPhoneNumber']);
          echo("</td><td>");
          echo($row['householdMemberEmailAddress']);
          echo("</td><td>");
          echo($row['ExistingMedicalConditions']);
          echo("</td><td>");
          echo('<input type="submit" value="Remove" id="');
          echo($row['HMIdentifier']);
          echo('" >');
          echo('<input type="hidden" name = "HMIdent" id = "HMIdent" value="');
          echo($row['HMIdentifier']);
          echo('" >');
          echo("</td></form></tr>\n");
      }
      echo "</table></center>\n"; 
?>
<br><br><br><center>
			<h2>Add new Household Member:</h2>

      <table border="solid" style = "text-align:center; width:40%; padding: 6px; 
  border-collapse: collapse;">
			<form method="POST" action = "Household.php">
            <br><tr><td>
            <label for="patientID">Patient&nbspName&nbsp:</label></td><td>
            <select id="patientID" name="patientID">
<?php

$statement = $pdo->query("SELECT PatientIdentifier, PatientName, PatientSurname FROM chwdetailedpatientassignment where StaffIdentifier = ".$_SESSION['StaffID']);
while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
	echo('<option value = "'.$row['PatientIdentifier'].'">'.$row['PatientName']." ".$row['PatientSurname'].'</option>');

}
?>
		</select></td></tr><tr><td>
	            <label for="MemberName">Member&nbspName&nbsp:</label></td><td>
	            <input type="text" name="MemberName" id="MemberName"></td></tr><tr><td>
	            <label for="MemberSurname">Member&nbspSurname&nbsp:</label></td><td>
	            <input type="text" name="MemberSurname" id="MemberSurname"></td></tr><tr><td>
	            <label for="CellphoneNumber">Cellphone&nbspNumber&nbsp:</label></td><td>
	            <input type="text" name="CellphoneNumber" id="CellphoneNumber"></td></tr><tr><td>
	            <label for="EmailAddress">Email&nbspAddress&nbsp:</label></td><td>
	            <input type="text" name="EmailAddress" id="EmailAddress"></td></tr><tr><td>
	            <label for="ExistingMedicalConditions">Existing&nbspMedical&nbspConditions&nbsp:</label></td><td>
	            <input type="text" name="ExistingMedicalConditions" id="ExistingMedicalConditions"></td></tr><tr><td>
	            <label for="RelationshipWithPatient">Relationship&nbspWith&nbspPatient&nbsp:</label></td><td>
	            <input type="text" name="RelationshipWithPatient" id="RelationshipWithPatient"></td></tr>

      </table><br>
	            <input type="submit" value="Add Household Member" id="submit" >
	        </form>
</center>


<br><br><br><center>
      <h2>Update Household Member Details:</h2>

      <table border="solid" style = "text-align:center; width:40%; padding: 6px; 
  border-collapse: collapse;">
      <form method="POST" action = "Household.php">
            <br><tr><td>
            <label for="memberID">Old&nbspMember&nbspDetails&nbsp:</label></td><td>
            <select id="memberID" name="memberID" style = "text-align-last:center;">
<?php

$statement = $pdo->query("SELECT PatientIdentifier, HMIdentifier, MemberName, MemberSurname, householdMemberPhoneNumber, householdMemberEmailAddress, ExistingMedicalConditions,RelationshipWithPatient  FROM chwstaffviewhouseholdmembers where StaffIdentifier = ".$_SESSION['StaffID']);
while ( $row = $statement->fetch(PDO::FETCH_ASSOC)) { 
  echo('<option value = "'.$row['HMIdentifier'].'">'.'Patient: '.$row['PatientIdentifier'].' -> '.$row['MemberName']." ".$row['MemberSurname']." ".$row['householdMemberPhoneNumber']." ".$row['householdMemberEmailAddress']." ".$row['ExistingMedicalConditions']." ".$row['RelationshipWithPatient'].'</option>');

}
?>
    </select></td></tr><tr><td>
              <label for="NewMemberName">Updated&nbspMember&nbspName&nbsp:</label></td><td>
              <input type="text" name="NewMemberName" id="NewMemberName"></td></tr><tr><td>
              <label for="NewMemberSurname">Updated&nbspMember&nbspSurname&nbsp:</label></td><td>
              <input type="text" name="NewMemberSurname" id="NewMemberSurname"></td></tr><tr><td>
              <label for="NewCellphoneNumber">Updated&nbspCellphone&nbspNumber&nbsp:</label></td><td>
              <input type="text" name="NewCellphoneNumber" id="NewCellphoneNumber"></td></tr><tr><td>
              <label for="EmailAddress">Updated&nbspEmail&nbspAddress&nbsp:</label></td><td>
              <input type="text" name="NewEmailAddress" id="NewEmailAddress"></td></tr><tr><td>
              <label for="NewExistingMedicalConditions">Updated&nbspExisting&nbspMedical&nbspConditions&nbsp:</label></td><td>
              <input type="text" name="NewExistingMedicalConditions" id="NewExistingMedicalConditions"></td></tr><tr><td>
              <label for="NewRelationshipWithPatient">Updated&nbspRelationship&nbspWith&nbspPatient&nbsp:</label></td><td>
              <input type="text" name="NewRelationshipWithPatient" id="NewRelationshipWithPatient"></td></tr>

      </table><br>
              <input type="submit" value="Update Household Member Information" id="submit" >
          </form>
</center>



    </body>
    <footer>
    	
    </footer>
</html>



