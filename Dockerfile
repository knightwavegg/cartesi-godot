FROM riscv64/ubuntu:22.04 as godot-build

RUN apt update && \
    apt install -y \
    build-essential \
    scons \
    pkg-config \
    libx11-dev \
    libxcursor-dev \
    libxinerama-dev \
    libgl1-mesa-dev \
    libglu-dev \
    libasound2-dev \
    libpulse-dev \
    libudev-dev \
    libxi-dev \
    libxrandr-dev \
    clang \
    llvm


COPY godot /opt/riscv/godot

WORKDIR /opt/riscv/godot

ENV GODOTFLAGS="use_llvm=yes arch=rv64 scu_build=yes debug_symbols=no fontconfig=no"
  
RUN scons $GODOTFLAGS

RUN cp bin/godot.linuxbsd.editor.rv64.llvm /usr/bin/godot

FROM riscv64/ubuntu:22.04

COPY --from=godot-build /usr/bin/godot /usr/bin/godot

WORKDIR /opt/riscv

RUN godot --headless --version