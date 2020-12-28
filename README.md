# DITA-OT Build GitHub action [<img src="https://www.dita-ot.org/images/dita-ot-logo.svg" align="right" height="55">](https://www.dita-ot.org)

This GitHub Action installs a version of the [DITA Open toolkit](https://www.dita-ot.org) and plus any relevant [DITA-OT plugins](https://www.dita-ot.org/plugins) and then builds a series of outputs such as a PDF document or an HTML static website.

## Inputs

### `dita-ot-version`

The version of DITA-OT to use. Defaults to `3.6`

### `prerequisites`

Comma separated list of additional DITA-OT plugins to install prior to installing the plugin under test.

### `setup-script`

The name of a bash script to run to install any dependencies prior to running the build. Defaults to `setup.sh` if not supplied.

### `ditamap`

The location of the ditamap to use to build the output. Defaults to `document.ditamap` if not supplied.

### `transtypes`

Comma separated list of transforms to run. Defaults to `pdf` only if not supplied.

### `properties`

A string representing any additional properties to pass into the input.

### `output-dir`

A string representing any additional properties to pass into the input. Defaults to `out` if not supplied.

## Example usage

```yaml
uses: jason-fox/dita-build-action@master
with:
    dita-ot-version: 3.6
    setup-script: 'startup.sh'
    prerequisites: 'org.doctales.xmltask,fox.jason.extend.css,fox.jason.prismjs'
    ditamap: 'docsrc/document.ditamap'
    transtypes: 'html5,pdf'
    properties: '--filter=filter1.ditaval'
    output-dir: 'out'
```

The artifacts can then be uploaded from your workflow as shown:

```yaml
uses: actions/upload-artifact@v2
with:
    name: my-artifact
    path: ~/out
```

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE)