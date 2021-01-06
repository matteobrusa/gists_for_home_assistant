
select * from states where entity_id="sensor.eta_total_consumption";

select substring(created,0,8) from states where entity_id="sensor.eta_total_consumption";

select distinct substr(created,0,11) from states where entity_id="sensor.eta_total_consumption";



select state_id,created,state from states where entity_id="sensor.eta_total_consumption" group by substr(created,0,11) ;


select state_id,created,state, ( state*10 -LAG ( state, 1, 0 ) OVER ( ORDER BY created)*10 )/10 from states where entity_id="sensor.eta_total_consumption" group by substr(created,0,11) ;

select state_id,created,state, ( state*10 -LAG ( state, 1, state ) OVER ( ORDER BY created)*10 )/10 from states where entity_id="sensor.eta_total_consumption" group by substr(created,0,11) ;


delete from states where entity_id="sensor.synth";
insert into states (domain, entity_id, state, attributes,last_changed,last_updated,created) 
select  "sensor","sensor.synth", ( state*10 -LAG ( state, 1, state ) OVER ( ORDER BY created)*10 )/10, '{"unit_of_measurement": "kg"}', last_changed, last_updated,created    
from states 
where entity_id="sensor.eta_total_consumption" group by substr(created,0,11) 
and created > (select max(created) from states where entity_id="sensor.synth");



create view v_daily_consumption as 
select  "sensor","sensor.synth", ( state*10 -LAG ( state, 1, state ) OVER ( ORDER BY created)*10 )/10, '{"unit_of_measurement": "kg"}', last_changed, last_updated,created    
from states 
where entity_id="sensor.eta_total_consumption" group by substr(created,0,11) ;


########################

select * from states where entity_id="sensor.synth";
select * from v_daily_consumption;
select max(created) from states where entity_id="sensor.synth";

insert into states (domain, entity_id, state, attributes,last_changed,last_updated,created) 
select * from v_daily_consumption limit 1;


insert into states (domain, entity_id, state, attributes,last_changed,last_updated,created) select * from v_daily_consumption where created > (select max(created) from states where entity_id="sensor.synth");

select * from states where entity_id="sensor.synth";


sqlite3 .homeassistant/home-assistant_v2.db 'insert into states (domain, entity_id, state, attributes,last_changed,last_updated,created) select * from v_daily_consumption where created > (select max(created) from states where entity_id="sensor.synth");'

