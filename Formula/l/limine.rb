class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.8.2/limine-10.8.2.tar.gz"
  sha256 "d53ee2ecbf7643412b1a2dc1ce021c4cd91c05470ffd5ee53c68db94916800a0"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "735d7f58d2c3e5b92009d0e8c159d028ed7b190453af8e29ac5ed759e3d82c36"
    sha256 arm64_sequoia: "4cd7beba53436642540df145a29286549ef1e07e32d5dcb4adcc978b0b022a1b"
    sha256 arm64_sonoma:  "4d14636345426058964da1fd4ad09613a836b48caa7109208a64f0696f24e656"
    sha256 sonoma:        "f33aecb41af922f4beee76f54774eae3518684be597a7d5ceea70847b91fcb15"
    sha256 arm64_linux:   "8403c435539f6ea38032052680a3c43ecf4ed4448400075ff4289fbe22935665"
    sha256 x86_64_linux:  "ffb747650170638696b17f7c8a9e1faf51d54ae6ea82b24ac9a1bbf4a5970392"
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