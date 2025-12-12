class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.5.0/limine-10.5.0.tar.gz"
  sha256 "da14c18eff4bda562cc44c69c7e2aebd9419ac1f1c8be32d76232eaa367503d2"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "88252c48d59d8fdfe40329330ae7e9aedac8e3112833904d507138cc6554b5df"
    sha256 arm64_sequoia: "d39a9cfe4926ec78659216364b3ac6ea54205046519c9f3d25a9e673ca8f96ab"
    sha256 arm64_sonoma:  "1810730b0349556e6e4676cd2baa8f21d814942833689c172a0d0fef8a9ea891"
    sha256 sonoma:        "a52df80afe9ddc8a4ab9901080752cf75f8335d99b142cebecc301069aa6b725"
    sha256 arm64_linux:   "b28c828db37e1735ae7b4b3ff7d64da60d8e3d5ff14e29f95845f1ad7f64d37f"
    sha256 x86_64_linux:  "5c1b0cc8b78390c2da093b951598a85a7327df4f8c978b15cfdace4b566429e2"
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
    llvm_bins = Formula["llvm"].opt_bin

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
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1")
    assert_match "installed successfully", output
  end
end