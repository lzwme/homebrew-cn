cask "gcc-aarch64-embedded" do
  # Exists as a cask because it is impractical as a formula:
  # https:github.comHomebrewhomebrew-corepull45780#issuecomment-569246452
  arch arm: "arm64", intel: "x86_64"

  version "13.2.rel1"
  pkg_version = "13.2.Rel1"
  gcc_version = "13.2.1"
  sha256 arm:   "88e51daf993dfc93d7ced3908b81f077ea18a89784ce5f398cdcd2ac6197435b",
         intel: "bbf320eb0a9115ba0f6a7de936805dfc6e19f767ed290032014a67443af87c20"

  url "https:developer.arm.com-mediaFilesdownloadsgnu#{version}binrelarm-gnu-toolchain-#{version}-darwin-#{arch}-aarch64-none-elf.pkg"
  name "GCC ARM Embedded"
  desc "Pre-built GNU bare-metal toolchain for 64-bit Arm processors"
  homepage "https:developer.arm.comTools%20and%20SoftwareGNU%20Toolchain"

  livecheck do
    url "https:developer.arm.comdownloads-arm-gnu-toolchain-downloads"
    regex(href=.*?arm-gnu-toolchain-(\d+\.\d+\.\w+)-darwin-(?:\w+)-aarch64-none-elf.pkgi)
  end

  pkg "arm-gnu-toolchain-#{version}-darwin-#{arch}-aarch64-none-elf.pkg"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-addr2line"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-ar"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-as"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-c++"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-c++filt"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-cpp"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-elfedit"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-g++"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gcc"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gcc-#{gcc_version}"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gcc-ar"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gcc-nm"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gcc-ranlib"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gcov"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gcov-dump"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gcov-tool"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gdb"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gdb-add-index"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gfortran"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-gprof"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-ld"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-ld.bfd"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-lto-dump"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-nm"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-objcopy"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-objdump"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-ranlib"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-readelf"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-size"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-strings"
  binary "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elfbinaarch64-none-elf-strip"

  uninstall pkgutil: "arm-gnu-toolchain-#{pkg_version}-darwin-#{arch}-aarch64-none-elf",
            delete:  "ApplicationsArmGNUToolchain#{pkg_version}aarch64-none-elf",
            rmdir:   [
              "ApplicationsArmGNUToolchain#{pkg_version}",
              "ApplicationsArmGNUToolchain",
            ]

  # No zap stanza required
end