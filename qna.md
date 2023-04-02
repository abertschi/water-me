# QnA for water_me

## Q: I want to create a backup
A: Starting from version 7, water_me includes a backup feature.
In the plant overview view, select Export/ Import Plants:

![image](https://user-images.githubusercontent.com/2311941/229356719-bbf97baf-1c44-43aa-a736-e4bf21f8d22b.png)


A json is created and stored to:

```
/storage/emulated/0/Android/data/ch.abertschi.waterme.water_me/files/water_me.json
```
![image](https://user-images.githubusercontent.com/2311941/229356730-4e4a303c-0751-4737-8813-e0f6073b9378.png)

Upon import, the current data is backuped to file `water_me.backup.json` in the same directory.
Pictures created with version 7 or later are stored in the same directory as well.
