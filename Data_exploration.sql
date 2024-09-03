--Beginner 
--List the top 10 orders with the highest sales from the EachOrderBreakdown table

select top 10 * from EachOrderBreakdown
order by sales desc

--Show the numbers of orders for each product category in the EachOrderBreakdown table

select Category, Count(category)from EachOrderBreakdown
group by Category

--Find the total Profit for each sub-category in the EachOrderBreakdown Table

select * from EachOrderBreakdown

select Subcategory ,sum(profit) as Profit from EachOrderBreakdown
group by SubCategory order by Profit desc



--Intermediate

--Identify The customer with the highest total sales across all orders

select * from OrdersList
select * from EachOrderBreakdown


select Top 3 CustomerName,Sum(Sales) as Total_Sales from OrdersList O
join EachOrderBreakdown E on O.OrderID=E.OrderID
group by CustomerName order by Total_Sales desc


--Find The Month With The highest Average sales in the OrderList Table
select Top 3 MONTH(OrderDate)as Month_name, avg(sales) as Average_Sales from OrdersList  as OL join
 EachOrderBreakdown as EOB on OL.OrderID=EOB.OrderID
 group by MONTH(OrderDate) Order by Average_Sales desc


 --Find Out The Average quantity Ordered By Customers whose first name start with an alphabet 'S'

 select CustomerName, Avg(Quantity) as Average_Quantity from OrdersList Ol
join EachOrderBreakdown Eob on Ol.OrderID=Eob.OrderID
group by CustomerName
 Having CustomerName Like 'S%' order by Average_Quantity desc



 --Advanced 
 --How many new customer were acquired in the year 2014?
 select count(*) As NumberOfCustomer from(
 select CustomerName,Min(OrderDate) As FirstOrder from OrdersList
 group by CustomerName 
 Having year(min(OrderDate))='2014' ) as CustWithFirstOrder2014



 --Calculated The Total Percentage of total profit contributed by the each sub-category to the overall profit
 select SubCategory,sum(Profit),
 sum(profit)/(Select sum(profit) from EachOrderBreakdown) * 100 As averageOfEach
 from EachOrderBreakdown
 group by SubCategory order by averageOfEach desc


 --Find The Average Sales Per Customer, Considering Only Customer Who have made more than 1 order.
 With CustomerAvgSales as (select CustomerName, count(Distinct Ol.OrderID) as NumberOfOrders,
 avg(sales) as Average_sales from OrdersList Ol
 join EachOrderBreakdown Eob on Ol.OrderID=Eob.OrderID
 group by CustomerName
 )
 select CustomerName,Average_Sales from CustomerAvgSales
 where NumberOfOrders>11 order by Average_sales desc

 --identify the top performing sub-category in each category based on total sales,include the sub-category
 With TopSubCategory as (select Category,SubCategory,sum(sales) as total_sales,
 Rank() over(partition by category order by sum(sales) desc) as SubCategoryRank
 from EachOrderBreakdown
 group by Category,SubCategory)
 select * from TopSubCategory
 where SubCategoryRank=1