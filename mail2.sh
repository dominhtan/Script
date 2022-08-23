#!/bin/sh

{ while IFS=';' read  u1 p1 u2 p2; do
imapsync --host1 115.146.127.14 --user1 $u1 --password1 $p1 --ssl1 --host2 52.98.66.98 --user2 $u2 --password2 $p2 --ssl2 --syncinternaldates
done; } < users.txt

// example users.txt: user001_1;password001_1;user001_2;password001_2
