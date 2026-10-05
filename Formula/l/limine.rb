class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.9.2/limine-12.9.2.tar.gz"
  sha256 "416bfd0368a66044bed0060415752377e11b7513190a1b2c62f865f652a5ac9e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "3bd4a3242691b8166c1d82a2453b0227726299d61fe7e3855f8ed57421cec77e"
    sha256 arm64_tahoe:       "28853e1df785a26828c527964f9336b6c9f83da02853293d2479a36ed53154ac"
    sha256 arm64_sequoia:     "8d9bb5591a3ef31b31c531500805a58091edc790f78a7b947cf039e0955ddac9"
    sha256 arm64_linux:       "09620bec9d0dfe53263e0cf204c98989aff663385b71e698ed99165c777c4129"
    sha256 x86_64_linux:      "6c7e9ad135555f8cb1724965a5229f5ec98e5c4794cb3a6989ef8c4c909bc4ce"
  end

  # The reason to have LLVM and LLD as dependencies here is because building the
  # bootloader is essentially decoupled from building any other normal host program;
  # the compiler, LLVM tools, and linker are used similarly as any other generator
  # creating any other non-program/library data file would be.
  # Adding LLVM and LLD ensures they are present and that they are at their most
  # updated version (unlike the host macOS LLVM which usually is not).
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "mtools" => :build
  depends_on "nasm" => :build

  deny_network_access!

  def install
    # Homebrew LLVM is not in path by default. Get the path to it, and override the
    # build system's defaults for the target tools.
    llvm_bins = formula_opt_bin("llvm")

    system "./configure", *std_configure_args, "--enable-all",
           "TOOLCHAIN_FOR_TARGET=#{llvm_bins}/llvm-",
           "CC_FOR_TARGET=#{llvm_bins}/clang",
           "LD_FOR_TARGET=ld.lld"
    system "make"
    system "make", "install"
  end

  test do
    bytes = 8 * 1024 * 1024 # 8M in bytes
    (testpath/"test.img").write("\0" * bytes)
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1", 1)
    assert_match "error: Could not determine if the device has a valid partition table.", output
  end
end