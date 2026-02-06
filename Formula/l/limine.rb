class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.6.6/limine-10.6.6.tar.gz"
  sha256 "c54d2eca0bea7967eccb916c6104001307341f5e63f1a996d34f7b1688f0d433"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ad63d4f3e73d4ca4559d01c5792fe97007f061da07a3312fed9e960cbe0a19ff"
    sha256 arm64_sequoia: "076ab98351b11e3a2a8deab7b1a9951ff12cfda7231c49a9ebacc21bce31d0b7"
    sha256 arm64_sonoma:  "b7b8ded2feab494da09b0d8bc21236ccc612a1a41db752e761012927b85ada9d"
    sha256 sonoma:        "00c62e653409bdadf8232fd3bdb23032dc47752594934d28bb317b36957e68d7"
    sha256 arm64_linux:   "262c34f280faa794944f00b9bfa733c5fba2ff0de9e7d613c604aa466b610839"
    sha256 x86_64_linux:  "3e06d2e241c69873eded86bf3e016c1b03c4cbe75de7369f546dea09a961413e"
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