--last 7 days Market Purchase

SELECT w.MetropolitanAreaId,
	   te.Warehouseid,
	   w.Name [Warehouse],
	   t.productvariantId PVID, 
	   pv.Name Product, 
	   count(t.productvariantId) [Product QTY]

FROM thingtransaction tss
JOIN thingevent te ON tss.id = te.thingtransactionid
JOIN thing t ON t.id = te.thingid
JOIN productvariant pv on pv.id = t.productvariantid
join warehouse w on w.Id=te.WarehouseId

WHERE t.CostPrice is not null
and tss.CreatedOn>='2022-02-19 00:00 +06:00'
and tss.CreatedOn<'2022-02-22 00:00 +06:00'
AND fromstate IN (262144, 536870912)
AND tostate IN (65536,16777216,268435456)
and t.ProductVariantId in (
	select ProductVariantId from ProductVariantCategoryMapping where CategoryId in (25,61) or ProductVariantId in (6568)
)

GROUP BY w.MetropolitanAreaId,te.Warehouseid,w.Name, t.productvariantId, pv.Name
--order by 4 desc
