# Zincir

Proof of concept distributed blockchain written in ruby.

### Install rubygems

```bash
$ bundle
```

### Start the first node

```bash
$ bundle exec ruby main.rb
Solved: 000008d0b97a697d303f46c7835ffdad23c78574df158169906aaf873e4906e7 1
Server started at http://localhost:4253
Solved: 00000d6d022947c5aba6308e802052a305eabdc7efb97f7ca275c6ef0e48fd70 2
Solved: 00000c289256068a869fc1a45d9381e609215928179123214c01a031423ff36e 3
Solved: 000000834d2d178965a668660dc5cec6e3a16498d928b899c3f3cbb17ebbca82 4
Node connected: http://localhost:4869
Received: 00000d3e95f7e557ffeefaa849c2c72e516a3971db409e37ebc9880e26eaef51 5
...
```

### Start additional nodes

```bash
$ bundle exec ruby main.rb ANOTHER_NODE_IP
Connecting to node: http://localhost:4253
Downloaded 000008d0b97a697d303f46c7835ffdad23c78574df158169906aaf873e4906e7 1
Downloaded 00000d6d022947c5aba6308e802052a305eabdc7efb97f7ca275c6ef0e48fd70 2
Downloaded 00000c289256068a869fc1a45d9381e609215928179123214c01a031423ff36e 3
Downloaded 000000834d2d178965a668660dc5cec6e3a16498d928b899c3f3cbb17ebbca82 4
Finished downloading the chain
Solved: 00000d3e95f7e557ffeefaa849c2c72e516a3971db409e37ebc9880e26eaef51 5
...
```

#### Implementation TODO

- Clean up code
- Don't use global variables: $blockchain, $network, $port
- Create a rubygem
- Disable Puma's startup message 

#### Protocol TODO

- Dump/load blockchain to/from a file when starting/exiting the process
- Make difficulty dynamic with the hash rate
- Specify a model for data
- Share list of connected nodes with other nodes
