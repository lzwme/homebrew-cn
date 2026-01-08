class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.6.2/limine-10.6.2.tar.gz"
  sha256 "587cefe29357488bba1f68bc32dc4eea8808cc1ed955c06a006cfecf36e614ab"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "144cdeba17680cd2d1555d636bd2cfe6bfdf91d0933a9ca819cc01c844f6791d"
    sha256 arm64_sequoia: "d0f3947c711aa10830ea110519aff774626494a4bfd08c27f05ad961362a3496"
    sha256 arm64_sonoma:  "0604b8ef56bb43d3cccc85fdf003e76a7c4eef56b52ad6d86239830e49ce19b1"
    sha256 sonoma:        "7238227ac9669dbbdc7891140be023672c0ade046ce5630b71dad18231a204b8"
    sha256 arm64_linux:   "dcb427998a7f1f2b4b85d5fe7e3266c435346198df7ba19356b179962ae4b1ca"
    sha256 x86_64_linux:  "77b8b2c8f4b700c65f9db28cfb2ef65a8fb1fb20e9189f6280e95e8903cb30c8"
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