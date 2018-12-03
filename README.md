# Zincir

Proof of concept blockchain written in ruby.

### Install rubygems

```
$ bundle
```

### Start the first node

```
$ bundle exec ruby main.rb
```

### Start additional nodes

```
$ bundle exec ruby main.rb ANOTHER_NODE_IP
```

#### TODO

- Don't use global variables: $blockchain, $network, $port
- Dump blockchain to a file when exiting the process
- Load blockchain from a dump if it exits
