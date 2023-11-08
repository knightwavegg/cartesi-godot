# cartesi-godot

This repo builds a RISC-V docker image containing Godot Engine, making it possible to run games made with Godot on the Cartesi Machine. The Godot repo is included as a submodule because it must be compiled for RISC-V as part of the build pipeline.

## To build

```
docker build . -t knightwavegg/cartesi-godot
```
