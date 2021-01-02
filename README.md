# DITA-OT Build GitHub action [<img src="https://www.dita-ot.org/images/dita-ot-logo.svg" align="right" height="55">](https://www.dita-ot.org)

This GitHub Action installs a version of the [DITA Open toolkit](https://www.dita-ot.org) and plus any relevant [DITA-OT plugins](https://www.dita-ot.org/plugins) and then builds a series of outputs such as a PDF document or an HTML static website.

## Inputs

### `transtype`

Name of the transform to run. Either `build` or `transtype` is required.

### `input`

The location of the topic or ditamap to use to build the output. Defaults to `document.ditamap` if not supplied.

### `output-path`

A string representing any additional properties to pass into the input. Defaults to `out` if not supplied.

### `properties`

A string representing any additional properties to pass into the input.

### `plugins`

Comma separated list of additional DITA-OT plugins to install.

### `install`

The name of a bash script to run to install plugins or any other dependencies prior to running the build. Script-based alternative to `plugins`

### `build`

Explicit command-line input or a bash script to run the DITA-OT Build.  Alternative to `transtype` and `properties`

### `dita-ot-version`

Downloads an explicit version of DITA-OT to use rather than using the default. Defaults to `3.6`


## Examples

### Install using `plugins`

```yaml
- name: Build HTML5 using DITA-OT
  uses: jason-fox/dita-build-action@master
  with:
      plugins : |
        fox.jason.extend.css
        org.doctales.xmltask
        fox.jason.prismjs
      input: document.ditamap
      transtype: html5
      output-path: out
```

### Install using command line statements

```yaml
- name: Build HTML5 using DITA-OT
  uses: jason-fox/dita-build-action@master
  with:
      install : |
        dita install fox.jason.extend.css
        dita install org.doctales.xmltask
        dita install fox.jason.prismjs
      input: document.ditamap
      transtype: html5
      output-path: out
```

### Install using a bash script

```yaml
- name: Build HTML5 using DITA-OT
  uses: jason-fox/dita-build-action@master
  with:
      install : install.sh # This is a script in the root of the repository
      input: document.ditamap
      transtype: html5
      output-path: out
```

### Build using command line statements only

```yaml
- name: Build PDF using DITA-OT commands
  uses: jason-fox/dita-build-action@master
  with:
      install : |
        dita install fox.jason.extend.css
        dita install org.doctales.xmltask
        dita install fox.jason.prismjs
      build: |
        dita -i document.ditamap -o out  -f pdf --filter=filter1.ditaval
```

## Example usage fixed to an explicit DITA-OT version and build properties

```yaml
- name: Build PDF using DITA-OT 3.5.4
  uses: jason-fox/dita-build-action@master
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

## Post-processing

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

The scripts and documentation in this project are released under the [MIT License](LICENSE)
