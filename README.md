To install this plugin, place it into the /plugins/ folder in your dita-ot 2.0
folder.  Once it is there, go to your dita-ot root folder and execute:
```bash
./startcmd.sh
ant -f integrator.xml
```

Once this is done, you should be ready to build your docs by doing:
```bash
./startcmd.sh
ant -Dargs.input=<path to .ditamap> -Doutput.dir=<output path> -Dtranstype=com.couchbase.docs.html
```
