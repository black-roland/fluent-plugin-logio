# fluent-plugin-logio
[Log.io](http://logio.org/) output plugin for Fluentd.

# Configuration

```
<match **>
  @type logio
  output_type json
  host localhost
  port 28777
</match>
```
