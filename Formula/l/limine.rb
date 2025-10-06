class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.1.0/limine-10.1.0.tar.gz"
  sha256 "1e7d678c268771d0a87272a901986470c5c6ead0288d5410b55016e295541462"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "aa0786227f08927dd47c2b777945f2f607c354282b100743a06401fa629b2867"
    sha256 arm64_sequoia: "9f21a71bce9abaaef158365d15f50892eacb1e491d3048ee0159364c2ecebe68"
    sha256 arm64_sonoma:  "cca5941a4598b37ccbb92e424102db0d80b50b853a7567012751a3eb7cccea10"
    sha256 sonoma:        "8ebae8da18a137c4d48940e60f906a08ba7d69e399b423ce321bf784075a7913"
    sha256 arm64_linux:   "cf25133553e4d54278d554753e7f923770a45ea316966a8b1c7871dafce50c05"
    sha256 x86_64_linux:  "9687259e65b0a022fb80c91006bf5b96906ab5e2144ac58dc87e866dacfb51b1"
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