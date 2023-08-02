# GitHub Action for DITA-OT Builds  [<img src="https://www.dita-ot.org/images/dita-ot-logo.svg" align="right" height="55">](https://www.dita-ot.org)

This GitHub Action installs a version of [DITA Open toolkit](https://www.dita-ot.org) along with any specified [DITA-OT plugins](https://www.dita-ot.org/plugins) and then builds a series of outputs such as a PDF document or an HTML static website.

## Inputs

### `transtype`

Name of the [DITA-OT transform](https://www.dita-ot.org/3.6/topics/output-formats.html) to run. One of `build` , `transtype`  or `project` is required.

### `input`

The location of the topic or ditamap to use to build the output. Defaults to `document.ditamap` if not supplied.

### `output-path`

Location for the DITA-OT build outputs. Defaults to `out` if not supplied.

### `properties`

A string representing any [additional parameters](https://www.dita-ot.org/3.6/parameters/parameters_intro.html) to pass into the input.

### `plugins`

Comma-separated list of additional [DITA-OT plugins](https://www.dita-ot.org/3.6/topics/adding-plugins.html) to install.

### `install`

The name of a bash script to run to [install plugins](https://www.dita-ot.org/3.6/topics/plugins-installing.html) or any other dependencies prior to running the build. Script-based alternative to `plugins`.

### `project`

Name of a DITA-OT [project file](https://www.dita-ot.org/3.6/topics/using-project-files.html) to run as an alternative to building using a
transtype. This will only run if `transtype` is not set.

### `build`

Explicit command-line input or path to a bash script to run the DITA-OT build
GitHub Action. This script will only run if  `transtype`  and `project` are
left unset.

### `dita-ot-version`

Downloads an explicit version of DITA-OT to use rather than using the default. Defaults to `3.6`.


## Examples

### Install

#### Install using `plugins`

Installation of plugins found within the [DITA-OT registry](https://github.com/dita-ot/registry)
can be referred to by name. A plugin also can be referrred to using a full path if necessary.

```yaml
- name: Build HTML5 using DITA-OT
  uses: dita-ot/dita-ot-action@master
  with:
      plugins : |
        https://github.com/jason-fox/fox.jason.extend.css/archive/master.zip
        org.doctales.xmltask
        fox.jason.prismjs
      input: document.ditamap
      transtype: html5
      output-path: out
```

#### Install using command line statements

Plugins can also be installed using the `dita` command.

```yaml
- name: Build HTML5 using DITA-OT
  uses: dita-ot/dita-ot-action@master
  with:
      install : |
        dita install https://github.com/jason-fox/fox.jason.extend.css/archive/master.zip
        dita install org.doctales.xmltask
        dita install fox.jason.prismjs
      input: document.ditamap
      transtype: html5
      output-path: out
```

#### Install with additional prerequisites

The following steps install [Node.js](https://nodejs.org/en) and switch the [locale](https://askubuntu.com/questions/193251/how-to-set-all-locale-settings-in-ubuntu) 
to **German**. By default, out of the box, the plugin only supports the **English** locale, 

```yaml
- name: Build HTML5 + Bootstrap
  uses: dita-ot/dita-ot-action@master
  with:
       install: |
            apt-get update -q
            export DEBIAN_FRONTEND=noninteractive
            apt-get install -qy --no-install-recommends nodejs
            nodejs -v
            locale-gen de_DE.UTF-8 
            LANG="de_DE.UTF-8"  
            LANGUAGE="de_DE:de"  
            LC_ALL="de_DE.UTF-8"
       plugins: |
            fox.jason.extend.css
            dita-bootstrap
            dita-bootstrap.lunr           
```

#### Install using a bash script

For complex prerequisites, an additional bash script can be added into the root of the repository

```yaml
- name: Build HTML5 using DITA-OT
  uses: dita-ot/dita-ot-action@master
  with:
      install : install.sh # This is a script in the root of the repository
      input: document.ditamap
      transtype: html5
      output-path: out
```

### Build

#### Build using a project file

The action supports the use of the [DITA-OT Project file](https://www.dita-ot.org/dev/topics/using-project-files.html)

```yaml
- name: Build HTML5 using DITA-OT
  uses: dita-ot/dita-ot-action@master
  with:
      plugins : |
        fox.jason.extend.css
        org.doctales.xmltask
        fox.jason.prismjs
      project: html.xml
```

#### Build using command line statements only

The action supports the use of the [`dita` command](https://www.dita-ot.org/dev/topics/build-using-dita-command.html)

```yaml
- name: Build PDF using DITA-OT commands
  uses: dita-ot/dita-ot-action@master
  with:
      install : |
        dita install fox.jason.extend.css
        dita install org.doctales.xmltask
        dita install fox.jason.prismjs
      build: |
        dita -i document.ditamap -o out  -f pdf --filter=filter1.ditaval
```

#### Example usage fixed to an explicit DITA-OT version and build properties

```yaml
- name: Build PDF using DITA-OT 3.5.4
  uses: dita-ot/dita-ot-action@master
  with:
      dita-ot-version: 3.5.4
      plugins: |
        org.doctales.xmltask
        fox.jason.extend.css
        fox.jason.prismjs
      input: 'docsrc/document.ditamap'
      transtype: 'pdf'
      properties: '--filter=filter1.ditaval'
      output-path: out
```

### Post-processing

The artifacts can then be uploaded from your workflow as shown:

```yaml
- name: Upload DITA
  uses: actions/upload-artifact@v2
  with:
      name: dita-artifact
      path: 'out' # The folder the action should upload.
```

Or deployed to GitHub Pages as shown:

```yaml
- name: Deploy to GitHub Pages
  uses: JamesIves/github-pages-deploy-action@3.7.1
  with:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    BRANCH: gh-pages # The branch the action should deploy to.
    FOLDER: out # The folder the action should deploy.
```

## License

The scripts and documentation in this project are released under the [Apache License 2.0](LICENSE).
