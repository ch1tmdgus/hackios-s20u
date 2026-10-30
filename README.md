# HackiOS on Galaxy S20 Ultra (z3q)

Experimental iOS 16 / XNU port for **Samsung Galaxy S20 Ultra 5G SM-G988N, Snapdragon 865 / Adreno 650**. This repository contains the source and local port changes; hardware support is incomplete.

Based on [hackios-xnu-userland](https://github.com/oosexgang/hackios-xnu-userland), the HackiOS XNU port, and [G986N-iOS](https://github.com/leh0726/G986N-iOS). See [the upstream port notes](docs/UPSTREAM-PORT-README.md) and [z3q hardware notes](docs/Z3Q.md).

## Status (2026-10-30)

- iOS home screen boots using an uploaded RAM system image.
- Samsung sec_ts touch and both volume keys work in device tests.
- Mesa/freedreno reports **FD650** for CoreAnimation OpenGL ES; GPU rendering is confirmed. Tested display submission intervals ranged around 35–53 frames/s; these are not a controlled benchmark.
- CPU frequency control and seven XNU cores work; a core remains with the loader.
- BCM4375 Wi-Fi associates and passes data. Intermittent disconnects remain; the SNonce retry patch is experimental and does not establish that rekeying is fixed.
- Speaker output is **not implemented for z3q**. The ADSP patch adds the Samsung carveout and relocatable firmware handling, with Samsung runs restricted to diagnostic steps 1–2. It has compiled but awaits physical validation.
- USB file transfer / SSH while running iOS is **not implemented**. Loader USB is a separate capability.

## Build and private inputs

Use `common/build.sh z3q` in the Linux cross-build environment described by the source scripts. A macOS host can use an ARM64 Linux Docker container. The toolchain, iPhoneOS SDK and iOS extraction must be supplied locally. `prebuilt` from older ports may lack the Samsung touch/Wi-Fi changes: build the kernel from source.

For graphics, build `AIR=1 tools/mk-mesa.sh`, then build userland with `GL=1` and compilation enabled (`PREBUILT=`). Verify that the resulting `root.apfs` contains `libOSMesa.8.dylib` and `libredwood-gl.dylib`. `gpu=1` alone does not provide the userland renderer.

Example after uploading the system RAM image with `XL_DEVICE=z3q ./xl ramdisk`:

```sh
env XL_DEVICE=z3q XL_SECS=300 XL_CMDLINE="cpus=8 bootcpu=7 cpufreq=1 touchscreen=1 buttons=1 gpu=1 wifi=1" ./xl run
```

`XL_SECS=0` disables the kernel return timer, but the current host script may incorrectly report a timeout after about 100 seconds. An unlimited run is not a stability guarantee.

This source upload excludes Apple system images/SDKs, device-extracted firmware, private keys, Wi-Fi credentials/MAC files, logs, partition backups and newly extracted UEFI binaries. The z3q DTB and UEFI vendor inputs must be supplied locally. Do not use another device's BOOT backup or partition geometry. Samsung uses the TWRP boot path; a generic `fastboot boot` command does not apply.

## Licensing

Preserve per-file copyright notices. `LICENSE` is APSL 2.0 for the XNU portion; `LICENSE-userland` retains the upstream MIT license for the userland portion. Other imported source files retain their own notices.
