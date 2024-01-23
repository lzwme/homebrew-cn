cask "gcc-arm-embedded" do
  # Exists as a cask because it is impractical as a formula:
  # https:github.comHomebrewhomebrew-corepull45780#issuecomment-569246452
  arch arm: "arm64", intel: "x86_64"

  version "13.2.rel1"
  pkg_version = "13.2.Rel1"
  gcc_version = "13.2.1"
  sha256 arm:   "57343df9a2d7c5c587b59ad011bf516ca286f6f9d0ef5957a3ad251f5579fd16",
         intel: "cba310dcd5e5b7f443ffea3ae4d6e00d757a616eb824ace6158c7473a8e2b33c"

  url "https:developer.arm.com-mediaFilesdownloadsgnu#{version}binrelarm-gnu-toolchain-#{version}-darwin-#{arch}-arm-none-eabi.pkg"
  name "GCC ARM Embedded"
  desc "Pre-built GNU bare-metal toolchain for 32-bit Arm processors"
  homepage "https:developer.arm.comTools%20and%20SoftwareGNU%20Toolchain"

  livecheck do
    url "https:developer.arm.comdownloads-arm-gnu-toolchain-downloads"
    regex(href=.*?arm-gnu-toolchain-(\d+\.\d+\.\w+)-darwin-(?:\w+)-arm-none-eabi.pkgi)
  end

  pkg "arm-gnu-toolchain-#{version}-darwin-#{arch}-arm-none-eabi.pkg"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-addr2line"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-ar"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-as"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-c++"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-c++filt"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-cpp"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-elfedit"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-g++"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gcc"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gcc-#{gcc_version}"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gcc-ar"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gcc-nm"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gcc-ranlib"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gcov"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gcov-dump"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gcov-tool"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gdb"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gdb-add-index"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gfortran"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-gprof"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-ld"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-ld.bfd"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-lto-dump"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-nm"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-objcopy"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-objdump"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-ranlib"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-readelf"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-size"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-strings"
  binary "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabibinarm-none-eabi-strip"

  uninstall pkgutil: "arm-gnu-toolchain-#{pkg_version}-darwin-#{arch}-arm-none-eabi",
            delete:  "ApplicationsArmGNUToolchain#{pkg_version}arm-none-eabi",
            rmdir:   [
              "ApplicationsArmGNUToolchain",
              "ApplicationsArmGNUToolchain#{pkg_version}",
            ]

  # No zap stanza required
end