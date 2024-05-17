create table battery                     (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL);
create table connected                   (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL);

create table numberOfChargingCycles      (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL);
create table numberOfCollisions          (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL);
create table totalChargingTime           (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL);
create table totalCuttingTime            (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL); 
create table totalDriveDistance          (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL);
create table totalRunningTime            (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL);
create table totalSearchingTime          (instant INTEGER PRIMARY KEY, measurement INTEGER NOT NULL);

create table position                    (instant INTEGER PRIMARY KEY, latitude REAL NOT NULL, longitude REAL NOT NULL);
