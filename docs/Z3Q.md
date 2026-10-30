# Galaxy S20 Ultra 5G (z3q, SM-G988N)

The y2q's (S20+) port moved to the S20 Ultra. Same SM8250, same GIC, same peripheral window, same framebuffer window, same
`sec_ts` touch (i2c 0x48, TLMM 15) and MAX77705 -- compared in the two phones' device trees; the UEFI drivers of the two
`xbl.img` are byte-identical but three (ChgDxe, DisplayDxe, DALSYSDxe); `uefiplat.cfg` is identical.

What differs, and where it is handled:

| | y2q | z3q |
|---|---|---|
| platform name in the loader | `y2q` | `z3q` (`xnuloader/loader.c`, built with `LOADER_TARGET=z3q`: both share `fb_base`, so one loader is built per phone; `common/build.sh` does it) |
| darwin | sda38, LBA 28904192.., 33554683 blocks | sda38, LBA 28904448..62458874, 33554427 blocks, GUID 489C5013-E662-4E33-ABE1-516B1AEAE907 (`loader.c`, `redwood_ufs.c`, `tools/darwin-write.py`) |
| kernel drivers gated on `y2q` | | `redwood_platform_is("y2q")` is also true on a z3q; `redwood_platform_exact` tells them apart (only the UFS darwin place does) |
| UEFI | `y2qPkg`, `Binaries/y2q` | `z3qPkg` (a copy), `Binaries/z3q` (y2q's, with ChgDxe/DisplayDxe/DALSYSDxe from the z3q's own xbl; DALSYSDxe patched at 0x2c50c) |
| DTB | board-id 14 | board-id 15, serials zeroed (`tools/dtb-scrub.py`) |

## Carving darwin out of userdata (done once, on the phone)

The z3q's `/data` is on a dm-default-key device (`dm-48`: metadata encryption), so its f2fs superblock is not readable from
the flash: the numbers come from the decrypted view. Done in this order, in Android with root, no reboot between 3 and 6:

1. dumps: `gpt-head.bin` (`dd if=/dev/block/sda bs=4096 count=8`), `gpt-tail.bin` (`skip=62458872 count=8`),
   `userdata-meta-before.bin` (first block of `/dev/block/dm-XX`), `segment_info-before.txt` (`/proc/fs/f2fs/dm-XX/`)
2. `tools/userdata-carve.py DIR 128` -- says what the kernel has to move out of the tail (1038 segments, about 1.85 GiB)
3. `tools/android/f2fs-resize /data 25888768`
4. `sb-after.bin`, `segment_info-after.txt` the same way
5. `tools/userdata-carve.py DIR 128` again: checks the shrunk f2fs, writes `gpt-head.new`, `gpt-tail.new`, `darwin-guid.txt`
6. `dd` them back (head blocks 2-3 and 1, tail blocks 4-7 at 62458876), read the GPT back and compare, then reboot

Verified on a G988N: Android boots with `/data` 99 GB and `darwin -> sda38`.

## Status

Historical bring-up notes below predate device testing. For current verified behavior and remaining limitations, see the repository README.
