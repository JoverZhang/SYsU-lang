# syntax=docker/dockerfile:1.4
FROM debian:unstable-slim
WORKDIR /autograder
WORKDIR /workspace
VOLUME /workspace
COPY <<build_install.sh <<run.sh . /workspace/SYsU-lang/
#!/bin/sh
rm -rf ~/sysu
cmake -G Ninja \\
    -DCMAKE_C_COMPILER=clang \\
    -DCMAKE_CXX_COMPILER=clang++ \\
    -DCMAKE_INSTALL_PREFIX=~/sysu \\
    -DCMAKE_MODULE_PATH="$(llvm-config --cmakedir)" \\
    -DCPACK_SOURCE_IGNORE_FILES=".git/;tester/third_party/" \\
    -S /workspace/SYsU-lang \\
    -B ~/sysu/build
cmake --build ~/sysu/build
cmake --build ~/sysu/build -t install
build_install.sh
#!/bin/sh
python3 -m tarfile -e /autograder/submission/*.tar.gz /workspace/submission
rm -rf /workspace/SYsU-lang/generator
cp -r /workspace/submission/*-Source/generator /workspace/SYsU-lang
rm -rf /workspace/SYsU-lang/optimizer
cp -r /workspace/submission/*-Source/optimizer /workspace/SYsU-lang
rm -rf /workspace/submission
~/build_install
mkdir -p /autograder/results
sysu-compiler \\
    --unittest=benchmark_generator_and_optimizer_1 \\
    --unittest-skip-filesize -1 \\
    "/workspace/SYsU-lang/**/*.sysu.c" >/autograder/results/results.json
run.sh
RUN <<EOF
apt update -y
apt upgrade -y
apt install --no-install-recommends -y \
    clang libclang-dev llvm-dev \
    zlib1g-dev lld-14 flex bison \
    ninja-build cmake python3 git
apt autoremove -y
apt clean -y
mv /workspace/SYsU-lang/run.sh /autograder/run
chmod +x /autograder/run
mv /workspace/SYsU-lang/build_install.sh ~/build_install
chmod +x ~/build_install
~/build_install
EOF
ENV PATH=~/sysu/bin:$PATH \
    CPATH=~/sysu/include:$CPATH \
    LIBRARY_PATH=~/sysu/lib:$LIBRARY_PATH \
    LD_LIBRARY_PATH=~/sysu/lib:$LD_LIBRARY_PATH
