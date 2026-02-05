class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.6.5/limine-10.6.5.tar.gz"
  sha256 "9334afa638a3caa8ae61be783fd9dd2fb8ea26c8c52ae12fa874fe3f5859fdcf"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "22528b9b2da0fd4c7396b29be14e0fdc67625262c90d8d9b2fd23ec68619aa7e"
    sha256 arm64_sequoia: "485ac82806f1e77203bc358f58326bb4596d286602f112dc32fa51d9ae2a34cf"
    sha256 arm64_sonoma:  "02ecca1dcc6a5c3db9e32f8f583ced58dc1b40906998f66607dbceb153be8749"
    sha256 sonoma:        "eb55fe950ad17daac12b74cca2f0b392442fd23f78402a45caae859f094f8c6f"
    sha256 arm64_linux:   "1fa72d044d4403ca294fe8582a3ab1cbdb6eb3b455bb4bd780ff7c4baa560d05"
    sha256 x86_64_linux:  "1b08cf253a75315375ea6e48d6b02e9083b7748ebc331bb9c99d6435fee3320a"
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