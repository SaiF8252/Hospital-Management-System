--DDL SQL--

drop database if exists HospitalManagementSystem
go

create database HospitalManagementSystem
on Primary (Name='HospitalManagementSystemMdf',
FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\HospitalManagementSyestem.mdf',
size=100MB,Maxsize=2000MB,filegrowth=5%)
LOG ON (nAME='HospitalManagementSystemLog',
filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\HospitalManagementSystem.ldf',
size=10MB,Maxsize=1000,filegrowth=2MB)
go
create login HospitalAdmin with password ='Admin@123', 
DEFAULT_DATABASE =HospitalManagementSystem ;
go

Alter Server Role ServerAdmin
add member hospitaladmin
go
use HospitalManagementSystem
Create ROLE AdminROLE
go
alter role db_owner
add member AdminRole
go
CREATE SCHEMA AdminSchema
GO
grant select,update,Delete,Execute
on Schema :: AdminSchema
to AdminRole
go
create user AdminUser for login HospitalAdmin
with default_Schema=AdminSchema
go
alter Role AdminRole
Add Member AdminUser


---


use HospitalManagementSystem
go
create table Departments
(DepartmentID INT PRIMARY KEY IDENTITY,
DepartmentName varchar(50)
)
go

Create TABLE PATIENTS
(
PatientsID INT PRIMARY KEY identity(100,1),
PatientName varchar (50),
Gender VARCHAR(10),
Age int,
Syndrome varchar(50),
IndoorPatients varchar(5) default 'YES',
OutdoorPatients varchar(5) default 'No'
)
go
create TABLE PatientDetails
(
PatientsID INT PRIMARY KEY REFERENCES PATIENTS(PatientsID),
BloodGroup VARCHAR(5) check (BloodGroup in('A+','A-','B+','B-','AB+','AB-','O+','O-')),
Contact VARCHAR(20) unique,
Address Varchar(50)
)

GO
create table Doctors
(Doctorid int identity primary key,
DoctorName varchar(50),
Specialization varchar (100),
ContactNumber varchar(20),
DepartmentID INT references departments(departmentid)
)
go
CREATE TABLE DoctorPatient
(
DoctorID INT,
PatientsID INT,
PRIMARY KEY (DoctorID, PatientsID),
FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
FOREIGN KEY (PatientsID) REFERENCES PATIENTS(PatientsID)
)

GO
create table Rooms
(Roomid int primary key identity(301,1),
RoomType Varchar(30),
CostPerDay money
)
go
create table Appointments
(AppointmentID int primary key identity,
Patientsid int references patients(patientsid),
Doctorid int references Doctors(doctorid),
AppointmentDate datetime,
Status varchar(20)
)
go
create table Admissions
(
AdmissionID INT PRIMARY KEY IDENTITY,
PatientID INT REFERENCES patients(patientsid),
Roomid int references rooms(roomid),
AdmissionDate dateTIme,
DischargeDate datetime
)
go
create Table TreatementRecord
(
TreatmentId int primary key identity(1,1),
DoctorId int foreign key references Doctors(doctorID),
PatientID int foreign key references Patients(PatientsID),
Treatment_Name varchar(50)
)
go
create Table MedicalServices
(
MediServiceID int PRIMARY KEY identity(1,1),
ServiceName varchar(50) not null,
ServiceFee money
)
go
create table Bills
(Billid int primary key nonclustered,
PatientID INT REFERENCES patients(patientsid),
MediServiceId int references MedicalServiceS(MediServiceId),
Quantity int not null,
UnitPrice Money,
TotalPrice money,check (TotalPrice>=0),
PaidAmount money not null,
IssueDate datetime,
PaymentStatus varchar(20)
)
go
--Add column--
alter table patients
add status varchar(10)
go
--Remove column--
aLTER Table Patients
drop column status;
go

--clustered index--
go
create clustered index ix_bills on bills(billid)
go
--create nonclusterd index--
create nonclustered index ix_doctors on doctors(doctorname)
go
--view,view with Schemabinding and encryption--
create view vw_patient

AS
Select D.DepartmentID,d.DepartmentName,
do.Doctorid,Do.DoctorName,Do.Specialization,do.ContactNumber

from Departments AS D
jOIN Doctors as Do
on d.DepartmentID=do.DepartmentID
go
--Schemabinding view--
create view vw_doctorsSchema
with schemabinding
as
select Doctorid,DoctorName
from dbo.Doctors
go
--view with encryption--
create view vw_appoinmentsEncrypt
with encryption
as
select *
from Appointments
go
--tABLE vARIAbles--
declare @AppointsmentsTable table
(Appointmentid int,
PatientID Int,
Doctorid int,
AppointmentDate date,
Status varchar(20)
)

insert into @AppointsmentsTable
VALUES
(35,20,9,GETDATE(),'Accepted')
go
--tEMPORARY Table--
create table #TemporaryTable
(patientsid int,
patientsname varchar(50),
gender varchar(10),
age int
)
select PatientName,Gender,Age
from PATIENTS;
go
select*
from #TemporaryTable
go
--gloBAL TEmporaryTable--
create table ##TemporaryTable
(patientsis int,
patientsname varchar(50),
gender varchar(10),
age int,
contact varchar(20)
)
select PatientName,Gender,Age,Gender,contact
from PATIENTS
go
--Stored Procedure iNSERT New Appointments--
create proc Sp_AddAppointsments
@PatientsName varchar(50),
@Gender varchar(10),
@Age int,
@Problem varchar(50),
@Contact varchar(20)
as
begin
     insert into PATIENTS
	 (PatientName,Gender,Age,Problem,contact)
	 values 
	 ('Younus','Male',28,'Insomnia','667676')
end
go
--Stored Procedure with Return--
create PRocedure Sp_Appointsment_Return
@PatientName varchar(50),
@Gender varchar(10),
@Age int,
@Problem varchar(30),
@Contact varchar(15)
as
begin 
    begin try
	    insert into PATIENTS(PatientName,Gender,Age,Problem,contact)
		values
		('Younus','Male',28,'Insomnia','667676');
		return 1
		end try
		begin catch
		Return 0
		End Catch
end


go
create PROc sp_dOCTORSoUTPUT
@DoctorID INT,
@DoctorName varchar(30),
@DeparmentID iNT OUTPUT
as
SELECT @DoctorID,count(*)
FROM Doctors
where DepartmentID>2


go
--sTORED pROCEDURE WITH Transaction--
create Procedure Sp_With_Trans_bills
@Patientsid int,
@Mediserviceid int,
@Quantity int
as
begin
     declare @unitprice money,
	 @totalprice money
begin try
begin tran
select @unitprice=ServiceFee 
from MedicalServices
where MediServiceID=@Mediserviceid
set @totalprice=@unitprice*@Quantity
insert into Bills
(PatientID,MediServiceId,Quantity,UnitPrice,TotalPrice,IssueDate)
values 
(1,1,5,1500,7500,getdate())

commit tran
end try
begin catch
rollback tran
print 'query failed'
end catch
end
go
--scalar function-
CREATE FUNCTION fnGetTotalBill
(
@BillID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
DECLARE @Total DECIMAL(10,2)

SELECT @Total = TotalPrice
FROM Bills
WHERE BillID = @BillID

RETURN @Total
END
go
--table valued function-
CREATE FUNCTION fnGetBillByPatient
(
@PatientID INT
)
RETURNS TABLE
AS
RETURN
(
SELECT BillID, MediServiceID, Quantity, TotalPrice, IssueDate, PaymentStatus
FROM Bills
WHERE PatientID = @PatientID
)
go
--multi valued function
CREATE FUNCTION fnGetHighValueBill
(
    @MinAmount DECIMAL(18,2)
)
RETURNS @HighBills TABLE
(
BillID INT,
PatientID INT,
TotalPrice DECIMAL(10,2),
PaymentStatus VARCHAR(20)
)
AS
BEGIN
    INSERT INTO @HighBills
    SELECT BillID, PatientID, TotalPrice, PaymentStatus
    FROM Bills
    WHERE TotalPrice >= @MinAmount

RETURN
END

go
--trigger--
create trigger TrPatientsInUPdL on patients
after insert,update,delete
as
begin
  set nocount on
  declare @Action varchar(20)
  if exists (select * from inserted) and exists(select * from deleted)
  set @Action = 'Update'
  else 
  if exists(select * from inserted)
  set @Action='insert'
  else
  if exists(select * from deleted)
  set @action= 'Delete'
  if @Action='insert' or @Action='update'
  begin
  insert into PATIENTS (PatientName,Gender,Age)
  select PatientName,Gender,Age from inserted
  end
  else
  if @Action= 'delete'
  begin
  insert into PATIENTS (PatientName,Gender,Age)
  select PatientName,Gender,Age from deleted
  end
end
--end ddl--

			