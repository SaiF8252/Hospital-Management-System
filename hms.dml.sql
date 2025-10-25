--DML Start--
use HospitalManagementSystem
--Select--
select * from Departments
select * from Doctors
select * from PATIENTS
select * from PatientDetails
select * from DoctorPatient
select * from Appointments
select * from Rooms
select * from Admissions
select * from TreatementRecord
select * from MedicalServices
select * from Bills
go
--insert--
INSERT INTO Departments
VALUES
('Cardiology'),('NEurology'),('General Medicine'),
('Pediatrics'),('Orthopedics'),('Gynecology & Obstetrics'),
('Oncology'),
('Ophthalmologist'),('DermatoLOGY'),('Psychiatry')

--insert into doctors table--
insert into Doctors
values
('Dr. Abdur Razzak','Cardiologist','55651',1),
('Dr.MOhitu Islam','Neurologist','556562',2),
('Dr.Jalal Uddin ','Medicine','55653',3),
('Dr.AKM Sadek','Pediatrician','55654',4),
('Dr.Md Selim','Orthopedic Surgeon','55655',5),
('Dr.Kamrun Nesa','Gynecologist','55657',6),
('Dr.Nasir Uddin','Oncologist','55657',7),
('Dr.Gias Uddin','Ophthalmologist','55658',8),
('Dr.Lubna Khandokar','Dermatologist','55659',9),
('Dr.Zia Uddin','Psychiatrist','55660',10)
go
--insert into Patients--

insert into patients
values
('Younus Ali','Male',29,'Sleep Apnea',default,default),
('Abu Rifat','Male',27,'Brugada',default,defaulT),
('Abdul Kader','Male',26,'Tourette',default,default),
('Nurul Amin','Male',28,'Metabolic',default,default),
('Meem','Female',26,'Down',default,default),
('Fahim','Male',28,'Marfan',default,default),
('Zobair','Male',26,'Li-Fraumini',default,default),
('Farzana','Female',30,'Polycystic Overy',default,default),
('Minhaz','Male',28,'Usher',default,default),
('Arafat','Male',28,'Stevens-Johnsons', DEFAULT, DEFAULT),
('Sakib','Male',26,'Aspergers','NO','YES')
go
Insert into PatientDetails
values
(101,'A+','45449','HaliShaHAr'),
(102,'A-','45450','Baddarhat'),
(103,'B+','45451','Chawkbazar'),
(104,'B-','45452','Crossing'),
(105,'AB+','45453','Agrabad'),
(106,'AB-','45454','Wasa'),
(107,'O+','45455','Chawkbazar'),
(108,'O-','45456','Chowmuhani'),
(109,'O-','45457','2NO GATE'),
(110,'AB+','45458','Potenga'),
(100,'B+','45460','Agrabad')
GO
--Insert into--
INSERT INTO DoctorPatient
VALUES
(4,105),
(5,108),
(10,110),
(1,100),
(1,101),
(2,100),
GO
insert into Rooms
values
('ICU', 20000),
('generalAC',5000),
('general',2000),
('childcare',3000),
('Nephrology',6000)
go
--insert into Appointsments--
insert into Appointments
values
(101,1,getdate(),'chest pain'),
(105,2,getdate(),'headache'),
(107,1,16/05/2025,'Arrhythmia'),
(109,2,15/06/2025,'headache')
--insert into admissions--
insert into Admissions
values
(104,301,getdate(),null),
(109,303,10/05/2025,null),
(107,306,getdate(),14/05/2025)
go
--insert in MedicalService--
INSERT INTO MedicalServices
VALUES
('x-RAY',1200),
('CT Scan',3400),
('dope test',1100),
('hbs(ags)',1200)
go
--insert in Treatment Record--
insert into TreatementRecord
values
(1,104,'cup Theropy'),
(2,105,'Neutration')
go
insert into Bills
values
(1,101,1,1,1200,1200,1000,getdate(),default),
(2,105,2,1,3400,3400,3400,getdate(),'paid')
go
--cte--
with AgeOver30
as
(
select p.PatientsID,p.PatientName,p.Age,p.Gender,p.contact
from PATIENTS as p
where Age>30
)
select *
from AgeOver30
go
--Recursive cte--
wITH AgeUnder30
as
(SELECT PatientsID,PatientName,Age
FROM PATIENTS
WHERE Age<=30

union all
select p.PatientsID,p.PatientName,p.Age
from PATIENTS as p
join PATIENTS
on p.PatientsID=patients.PatientsID
)
SELECT *
FROM AgeUnder30
go
--show view--
select *
from dbo.vw_doctors
where Doctorid>1
--insert view--
insert into dbo.vw_doctors 
values
('Md Shakawat Jamil','heart Specialist','98989',5)
--update view--
update vw_doctors
set DoctorName='Mr.Khan'
where Doctorid=1
--delete view-
delete from vw_doctors
where DoctorName='mr.khan'

--show view with schem--
select *
from dbo.vw_patients
go
--distinct--
select distinct* 
from PATIENTS
go
--select into
select *
into mypatients
from PATIENTS

select *
from mypatients
go
--trancate table
truncate table mypatients
go
--join--
select p.PatientsID,p.PatientName,pd.Address,pd.BloodGroup
from PATIENTS p
join PatientDetails pd
on p.PatientsID=pd.PatientsID
--left,right,full join,cross join--
select *
from PATIENTS p
left join PatientDetails pd
on p.PatientsID=pd.PatientsID
go
select *
from PATIENTS p
right join PatientDetails pd
on p.PatientsID=pd.PatientsID
go
select *
from PATIENTS p
full join PatientDetails pd
on p.PatientsID=pd.PatientsID
go
select *
from PATIENTS p
cross join PatientDetails pd
go
--merge statement--
merge patients as p
using bills as b
on p.patientsid=b.patientsid
--call table variables--
select *
from @Appointsmentstable
--call temporary table-current seasion only--
select *
from #temporarytable
GO
--call Global temporary table-all seasion until the last season end --
select *
from  ##TemporaryTable
GO
--call procedure--
exec Sp_AddAppointsments
'Younus','Male',28,'Insomnia','667676'
GO
--call procedure with return--
DECLARE @Result int
exec @Result =Sp_Appointsment_Return
@PatientName ='Younus',
@Gender= 'Male',
@Age=28,
@Problem= 'Insomnia',
@Contact = '667676'
if @Result=1
print 'Patient Added'
else
print 'patient add failed';
 
--table valued function--

--table valued function--
--trigger--