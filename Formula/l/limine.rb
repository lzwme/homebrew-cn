class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.8.0/limine-12.8.0.tar.gz"
  sha256 "6fe2209457cb342ccf102d270ba953153138a191546c7801ed8ee9a6b2dcee4b"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "81c1e8ee23da824face8badb1df201eb3dc134bd393ef49d7e596c7802e6c970"
    sha256 arm64_sequoia: "fd697264ac8aeb35260523e4c29b10e044b6f6e6c995d46c785b1aa66fdc14d2"
    sha256 arm64_sonoma:  "c1ea6cdebe7aa8f4944e0020acf334849c441a9aaee14c375b31dc765a50e71d"
    sha256 arm64_linux:   "2e99f1650c8eba7f1d0417da8240d09c538807fbdde46e1f61277561a6b1f58b"
    sha256 x86_64_linux:  "968d8a092c24a803a181275684b14e475c09070aa08421573e16e0acd3a09cf8"
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