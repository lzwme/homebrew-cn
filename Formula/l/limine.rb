class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.6.1/limine-12.6.1.tar.gz"
  sha256 "76de3768cdd106ff54cdcbaa25c563971ee41ea17b11a9b0ffd5573d2b025c00"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b960d16d741f2e71f7b4be917fd886e75444bb387f2436b4a176b175f8b43b39"
    sha256 arm64_sequoia: "37abbfef2bece3fa3fb2dffae3816b25a5935e0893eb245db9344e6a0040c670"
    sha256 arm64_sonoma:  "e71b104ac4007438ccc6e2264da07706a5c9d30105f9e156649bf8f3eebe4247"
    sha256 sonoma:        "6882a2928bca75a0a1f103f7450853e410b782e96d6f280cf484fcf9c42dc3ca"
    sha256 arm64_linux:   "193261e4ae6d0abc5b6cac3b59497e3466458d66382815a3aff543392cd71af6"
    sha256 x86_64_linux:  "f70781a317c785efd46bee3ecf588f749a61f0940d123b43c1223d74fb5a7115"
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