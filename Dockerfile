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
RUN cp bin/godot.linuxbsd.editor.rv64.llvm /usr/local/bin/godot

# Run a second build for the export template
RUN scons $GODOTFLAGS target=template_debug

FROM riscv64/ubuntu:22.04

WORKDIR /opt/riscv

ENV TEMPLATE_DIR=/root/.local/share/godot/export_templates/4.2.1.stable/

COPY --from=godot-build /usr/local/bin/godot /usr/local/bin/godot

RUN mkdir -p $TEMPLATE_DIR
COPY --from=godot-build /opt/riscv/godot/bin/godot.linuxbsd.template_debug.rv64.llvm $TEMPLATE_DIR/linux_debug.x86_64

CMD godot --headless --version