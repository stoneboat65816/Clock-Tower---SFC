copy ClockTower.sfc ClockTower_VN.smc

atlas -d log.txt ClockTower_VN.smc CTVN_kaiwa.txt
xkas.exe -o ClockTower_VN.smc  CT_main.asm

pause