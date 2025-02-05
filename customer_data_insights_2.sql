SELECT 
    dc.city_name,                                                                        
    dd.month_name,                                                                       
    COUNT(ft.trip_id) AS actual_trips,                                                   
    tmt.total_target_trips AS target_trips,                                              
    CASE
        WHEN COUNT(ft.trip_id) > tmt.total_target_trips THEN 'Above Target'              
        ELSE 'Below Target'                                                             
    END AS performance_status,                                                           
    CONCAT( 																			 
    ROUND(
        ((COUNT(ft.trip_id) - tmt.total_target_trips) * 100.0 / tmt.total_target_trips), 
        2),
        "%"
    ) AS pct_difference                                                                 
FROM
    fact_trips ft                                                                        
JOIN
    dim_city dc ON ft.city_id = dc.city_id                                               
JOIN
    dim_date dd ON ft.date = dd.date                                                     
JOIN
    targets_db.monthly_target_trips tmt 												 
    ON dc.city_id = tmt.city_id                                                       
    AND dd.start_of_month = tmt.month                                                    
GROUP BY 
    dc.city_name,                                                                        
    dd.month_name,                                                                      
    tmt.total_target_trips,                                                           
    dd.start_of_month                                                                    
ORDER BY 
    dc.city_name,                                                                  
    MONTH(dd.start_of_month);                                                            