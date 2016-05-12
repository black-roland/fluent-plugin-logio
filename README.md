# fluent-plugin-logio
[Log.io](http://logio.org/) output plugin for Fluentd.

# Installation

This fluentd plugin is available as the fluent-plugin-logio gem from RubyGems.

```shell
gem install fluent-plugin-logio
```

Or you can install this plugin for td-agent as:

```shell
td-agent-gem install fluent-plugin-logio
```

# Configuration

```
<match **>
  @type logio
  output_type json
  host localhost
  port 28777
</match>
```
