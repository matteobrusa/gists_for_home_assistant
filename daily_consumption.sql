

# drop view v_daily_consumption;

create view if not exists v_daily_consumption as  
select substr(created,0,12) || "12:00:00" as created, state as last, ( state*10 -LAG ( state, 1, state ) OVER ( ORDER BY created)*10 )/10 as consumption from
    (
    select state_id, datetime(created, "-1 day") as created, state 
    from states where entity_id="sensor.eta_total_consumption" group by substr(created,0,11)
    union all 
    select * from (select state_id, created, state
    from states where entity_id="sensor.eta_total_consumption" order by created desc limit 1 )
    );


DELETE FROM states WHERE entity_id="sensor.synth" and state_id = (SELECT MAX(state_id) FROM states WHERE entity_id="sensor.synth");
delete from states where entity_id="sensor.synth" and event_id is not null;
insert into states (domain, entity_id, state, attributes,last_changed,last_updated,created) 
    select "sensor","sensor.synth", consumption as state, '{"unit_of_measurement": "kg"}', created, created, created 
    from v_daily_consumption 
    where created > ifnull( (select max(created) from states where entity_id="sensor.synth"),0 );
