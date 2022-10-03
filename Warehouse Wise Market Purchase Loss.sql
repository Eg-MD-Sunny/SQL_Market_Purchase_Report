---Warehouse Wise Market Purchase

SELECT pv.Id PVID,
       pv.Name ProductName,
       sum(t.costprice) TotalCostAmmount,
       SUM(tr.SalePrice) as TotalSaleAmmount,
       (sum(t.costprice)-SUM(tr.SalePrice)) LossAmmount,
       w.Id WarehouseId,
       w.Name WarehouseName,
       c.name CategoryName,
       CAST(dbo.tobdt(tss.CreatedOn) as DATE) BuyDate,
       dbo.GetEnumName('CreationEventType',CreationEventType) CreationEventType,
       count(*) ProductCount,
       de.Id DesignationId,
       de.DesignationName

FROM thingtransaction tss 
JOIN thingevent te ON tss.id = te.thingtransactionid 
JOIN thing t ON t.id = te.thingid 
JOIN productvariant pv on pv.id = t.productvariantid
join ThingRequest tr on tr.AssignedThingId=t.id
join shipment s on tr.ShipmentId=s.Id
left join employee e on e.id=tss.CreatedByCustomerId
left join Designation de on de.id=e.DesignationId
join ProductVariantCategoryMapping pcm on pcm.ProductVariantId=pv.Id
join Category c on pcm.CategoryId=c.Id
join Warehouse w on te.WarehouseId=w.Id

WHERE tss.CreatedOn >= '2022-02-15 00:00 +06:00'
and tss.CreatedOn < '2022-02-16 00:00 +06:00'
AND tostate IN ( 65536,16777216,268435456 ) 
AND fromstate IN ( 262144, 536870912 ) 
AND pv.deleted = 0 
and c.Id in (11, 12 , 25, 61, 1237)
and t.CostPrice is not null
and t.costprice > tr.SalePrice

GROUP BY pv.Id,
         pv.Name,
		 w.Id,
		 w.Name,
		 c.name,
		 CAST(dbo.tobdt(tss.CreatedOn) as DATE),
		 dbo.GetEnumName('CreationEventType',CreationEventType),
		 de.Id,de.DesignationName
order by 6 asc, 8 asc, 5 desc



--Shelving Query (Previous Day 9:00 PM to Recent Day 07:00 AM)

--#################################################################################
-- Geting Mising Damage Min & Max ThingId

SELECT max(te.ThingId) MaximumThingId,min(te.ThingId) MinimumThingId
FROM ThingEvent te
JOIN ThingTransaction tt on tt.id = te.ThingTransactionId
WHERE tt.CreatedOn >= '2022-01-21 21:00 +6:00'
AND tt.CreatedOn < '2022-01-22 08:00 +6:00'
AND ToState in ( 256,34359738368 )