# BBB load-pru-firmware helper

A simple bash script that installs PRU's firmware on **Beaglebone Black** (that have only **PRU0** and **PRU1**).

#### **ONLY FOR REMOTEPROC STYLE OF LIFE!**

How to use:

Let's say you have a `button_led_1.out` (located at `/home/debian/PRU_testing/pru-software-support-package-5.6.0/labs/Hands_on_Labs/lab_2/solution/button_led_1/gen/`) file that you want to load to **PRU1**. So:

```
$ chmod +x load_pru_fimware.sh
$ load_pru_firmware.sh /home/debian/PRU_testing/pru-software-support-package-5.6.0/labs/Hands_on_Labs/lab_2/solution/button_led_1/gen/ 1

---------- PRU1 choosed ----------


- - - - -  Stopping PRU  - - - - -
PRU1 already stopped!


- - - - - Loading firmware - - - - -
Loading firmware file button_led_1.out
command: sudo cp /home/debian/PRU_testing/pru-software-support-package-5.6.0/labs/Hands_on_Labs/lab_2/solution/button_led_1/gen/button_led_1.out /lib/firmware/am335x-pru1-fw
[sudo] password for debian: 


- - - - -   Starting PRU   - - - - -
Starting PRU1
command: echo start > /sys/class/remoteproc/remoteproc2/state

----------     DONE!     ----------
```

## TODO

Perhaps load firmwares for both PRU's with this script. Perhaps some options about it... 