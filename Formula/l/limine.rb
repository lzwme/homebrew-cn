class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v11.1.0/limine-11.1.0.tar.gz"
  sha256 "ef4585442b5cde1fc0b32e59668a16dd283f96780f178364e283e6feafe98460"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d9125d7b8806cf0c8ea7e7a8e23f859baad26f076a503d986ddf553846784c1f"
    sha256 arm64_sequoia: "51cdf28d1f4485eac1ef2d954b10fe9317a5dc7b0e5ca26eaa448fb7ddd2b1b0"
    sha256 arm64_sonoma:  "16885bf0498be1032a9fd2e6ef61e2978e246263c11f827ef765fbcab07cadfd"
    sha256 sonoma:        "e13001cfeeec860128e20cf9161a114aa1f18b91010b90558cc30a34ec8475ba"
    sha256 arm64_linux:   "26dbb78ba820887d3b7c93aa7411d0366eeb1424e22a24e51d8143421f133028"
    sha256 x86_64_linux:  "49cb3c3c027b740ae913dbcb63b3033a13e6a06d52f443af6aed08c4d2ff6d76"
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