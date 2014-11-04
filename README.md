To use this plugin, here is a short rundown of how to get set up.

1. Download DITA-OT 2 Milestone 4
   http://sourceforge.net/projects/dita-ot/files/DITA-OT%20Latest%20Test%20Build/DITA-OT%202.0/DITA-OT2.0.M4_full_easy_install_bin.tar.gz/download
1. Extract DITA-OT to somewhere, lets call it $DITA_HOME
1. Clone this repository to your DITA plugins folder
   `git clone https://github.com/brett19/docs-dita-plugin.git $DITA_HOME/plugins/com.couchbase.docs.html`
1. Ensure you are currently in your $DITA_HOME folder.
1. Launch the DITA shell.
   `./startcmd.sh`
1. Integrate the plugin with your DITA-OT installation:
   `ant -f integrator.xml`
1. Build your docs (Note: paths must be absolute):
   1. To build the developer documentation:
      `ant -DnoImagelist=1 -Dargs.devguide=yes -Dargs.input={YOUR_DOCS_DIR}/developer/developer.ditamap -Doutput.dir={OUTPUT_FOLDER}/developer -Dtranstype=com.couchbase.docs.html`
   1. To build the administrator documentation:
      `ant -DnoImagelist=1 -Dargs.devguide=no -Dargs.input={YOUR_DOCS_DIR}/learn/learn.ditamap -Doutput.dir={OUTPUT_FOLDER}/admin -Dtranstype=com.couchbase.docs.html`

Here is a full example of installing and building the developer docs to MacOS built in webserver:
```bash
$ cd /tmp
$ wget {$DITA_OT_URL}
$ tar xzvf {$DITA_OT} ~/docs-devkit
$ cd ~/docs-devkit
$ git clone -b newdocs https://github.com/brett19/docs-dita-plugin.git plugins/com.couchbase.docs.html
$ ./startcmd.sh
$ ant -f integrator.xml
$ ant -DnoImagelist=1 -Dargs.devguide=yes -Dargs.input=/cb-docs/developer/developer.ditamap -Doutput.dir=/Library/WebServer/Documents/developer -Dtranstype=com.couchbase.docs.html
```
