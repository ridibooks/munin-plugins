# Munin-plugins

Collection of munin plugins

# Installation

```shell
git clone https://github.com/ridibooks/munin-plugins.git
chmod +x munin-plugins/src/*.sh
cp munin-plugins/src/*.sh /etc/munin/plugins
service munin-node restart
```

# Installation on ridi

```shell
git clone https://github.com/ridibooks/munin-plugins.git
chmod +x munin-plugins/src/*.sh
find munin-plugins/src -type f -name '*.sh' -print0 | xargs --null -I{} mv {} {}.ridi.sh
rm /etc/munin/plugins/*.ridi.sh
cp munin-plugins/src/*.ridi.sh /etc/munin/plugins
service munin-node restart
```

# Plugins

## megaraid.error.sh

### target

- Megaraid raid controller error 

### requirements

- storcli - http://www.lsi.com/support/pages/download-results.aspx?keyword=storcli
- php

## mysql.replication.sh

### target

- Mysql replication status monitor (on | off)

### requirements

- php
