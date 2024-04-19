#windows-server #hpe #hyper-v #raid

- expanding the [[RAID]] 5 array on **HPE Smart Array P408i-a Gen10** ([[HPE Server]])
- tools used: 
					- SSACLI (HPE Smart Storage Administrator)
					- [[DISKPART]]
### Before expansion:

**check the current configuration:**
- run the *SSACLI* from Windows command line / Powershell
```ssacli
ctrl all show config
```

   Array A (Solid State SATA, Unused Space: 0  MB)

      logicaldrive 1 (5.24 TB, RAID 5, OK)

      physicaldrive 2I:3:5 (port 2I:box 3:bay 5, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:6 (port 2I:box 3:bay 6, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:7 (port 2I:box 3:bay 7, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:8 (port 2I:box 3:bay 8, SATA SSD, 1.9 TB, OK)



- we need to add another 1.9TB SSD drive to expand the capacity of the logical drive 1

**expand the array:**
```ssacli
ctrl slot=0 array A add drives=1I:3:4
```
this will take some time

   Array A (Solid State SATA, **Unused Space: 2289235  MB)**

      logicaldrive 1 (5.24 TB, RAID 5, OK)

      physicaldrive 1I:3:4 (port 1I:box 3:bay 4, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:5 (port 2I:box 3:bay 5, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:6 (port 2I:box 3:bay 6, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:7 (port 2I:box 3:bay 7, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:8 (port 2I:box 3:bay 8, SATA SSD, 1.9 TB, OK)


- after expanding the array we need to also expand the Logical Drive 1 so it will be usable

**expand the logical drive 1 size:**
```ssacli
ctrl slot=0 ld 1 modify size=max forced
```

### After expansion:

   Array A (Solid State SATA, **Unused Space: 0  MB)**

      logicaldrive 1 (6.99 TB, RAID 5, OK)

      physicaldrive 1I:3:4 (port 1I:box 3:bay 4, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:5 (port 2I:box 3:bay 5, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:6 (port 2I:box 3:bay 6, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:7 (port 2I:box 3:bay 7, SATA SSD, 1.9 TB, OK)
      physicaldrive 2I:3:8 (port 2I:box 3:bay 8, SATA SSD, 1.9 TB, OK)


### Expand partition on the Hyper-V server

- now we need to expand the partition on our [[Hyper-V]] either with Diskpart or Disk Management

```cmd
diskpart

list disk

select disk X
select partition X

extend
```

**done.**