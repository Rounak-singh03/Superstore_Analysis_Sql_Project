--Question 01->Establish The Relation Between tables as per the ER Diagram.

alter table OrdersList
alter column OrderID nvarchar(255) Not Null

alter table OrdersList
Add Constraint pk_orderID primary key(OrderID)

alter table EachOrderBreakdown
alter column OrderID nvarchar(255) Not Null

alter table EachOrderBreakdown
add constraint fk_orderID foreign key(OrderID) references OrdersList(OrderID)


--Question 02--> Split City State Country into three individual column name like 'City','State','Country'
alter table OrdersList
add City nvarchar(255),
    State nvarchar(255),
	Country nvarchar(255)

update OrdersList
set City=parsename(REPLACE([City State Country],',','.'),3),
    State=parsename(REPLACE([City State Country],',','.'),2),
	Country=parsename(REPLACE([City State Country],',','.'),1)

Alter Table OrdersList
drop column [City State Country]

select * from OrdersList

--Question 03--> Add a new Category Column using the following mapping as per the first 3 Characters in the product name column
--A.TEC-Technology
--B.OFS-Office Supplies
--C.FUR-Furniture
select * from EachOrderBreakdown


alter table EachOrderBreakdown
add Category nvarchar(255)


update EachOrderBreakdown
set Category= Case When LEFT(ProductName,3)='OFS' Then 'Office Supplies'
                   When LEFT(ProductName,3)='FUR' Then 'Furniture'
				   when LEFT(ProductName,3)='TEC' Then 'Technology'
			  End;


--Question 04--> Delete the first 4 Character From The ProductName column
update EachOrderBreakdown
set ProductName=SUBSTRING(ProductName,5,len(ProductName)-4)

update EachOrderBreakdown
set ProductName=REPLACE(ProductName,'-','')

update EachOrderBreakdown
set ProductName=TRIM(ProductName)

select *from EachOrderBreakdown


--Question 05--> Remove all Duplicated row from EachOrderBreakdown Table,If All Column value are matching
with CTE as (select * , ROW_NUMBER() over(partition by OrderID,ProductName,Discount,Sales,Profit,
Quantity,SubCategory,Category order by OrderID) as RN
 from EachOrderBreakdown)
 delete from CTE
 where RN>1


 --Question 06--> Replace Blank With NA in OrderPriority Column in OrderListTable

 select * from OrdersList

 update OrdersList
 set OrderPriority= Case when OrderPriority='' Then 'NA'
                     end;


update OrdersList
set OrderPriority=REPLACE(OrderPriority,'NA','')


UPDATE OrdersList
SET OrderPriority = 'Critical'
WHERE OrderPriority IS NULL;