# QnA for water_me

## Q: I want to create a backup
A: Starting from version 7, water_me includes a backup feature.
In the plant overview view, select Export/ Import Plants:

A json is created and stored to:

```
/storage/emulated/0/Android/data/ch.abertschi.waterme.water_me/files/water_me.json
```

Upon import, the current data is backuped to file `water_me.backup.json` in the same directory.
Pictures created with version 7 or later are stored in the same directory as well.
