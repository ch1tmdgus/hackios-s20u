##
#  Copyright (c) 2011 - 2022, ARM Limited. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#  Copyright (c) 2015 - 2020, Intel Corporation. All rights reserved.
#  Copyright (c) 2018, Bingxing Wang. All rights reserved.
#  Copyright (c) Microsoft Corporation.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
##

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = z3q
  PLATFORM_GUID                  = 8823E645-752D-4445-B81F-C383DC5F459D
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/z3qPkg
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = RELEASE|DEBUG
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = z3qPkg/z3q.fdf
  USE_CUSTOM_DISPLAY_DRIVER      = 0

  #
  # 0 = SM8250
  # 1 = SM8250-AB
  # 2 = SM8250-AC
  #
  SOC_TYPE                       = 0

!include KonaPkg/KonaPkg.dsc.inc

[PcdsFixedAtBuild]
  #
  # DDR Memory
  #
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x80000000

  #
  # UEFI Stack
  #
  gArmPlatformTokenSpaceGuid.PcdCPUCoresStackBase|0x9FF90000
  gArmPlatformTokenSpaceGuid.PcdCPUCorePrimaryStackSize|0x40000

  #
  # SMBIOS
  #
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemManufacturer|"Samsung"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemRetailModel|"z3q"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemModel|"Galaxy S20+ 5G"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemRetailSku|"Galaxy_S20_Ultra_5G_z3q"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemBoardModel|"Galaxy S20+ 5G"

  #
  # Simple Frame Buffer
  #
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferWidth|1440
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferHeight|3200
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferColorDepth|32

  #
  # Platform PEI
  #
  gQcomPkgTokenSpaceGuid.PcdPlatformType|"LA"

[LibraryClasses]
  #
  # Memory Libraries
  #
  MemoryMapLib|z3qPkg/Library/MemoryMapLib/MemoryMapLib.inf

  #
  # QCOM Libraries
  #
  ConfigurationMapLib|z3qPkg/Library/ConfigurationMapLib/ConfigurationMapLib.inf

[Components]
  #
  # ACPI Tables
  #
  #z3q/AcpiTables.inf
