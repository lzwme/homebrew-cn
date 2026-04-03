class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v11.2.0/limine-11.2.0.tar.gz"
  sha256 "2d68e2677b9909572eab52c3b9bbbe1bf5a34d2e34d8f98490cbac01917ac654"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4a06ab344de01c8f9b50fbd31d9ecbe385b20ee54e8658ca66be83b703f50856"
    sha256 arm64_sequoia: "b6f25b40eee8695c84eed53400c2a5a8bf41fbfe9e4f215164fa3cd07be79a16"
    sha256 arm64_sonoma:  "1dd0e382941f2863abbd7a5d9c6f7bb0a360da181dcb1fc7ae64d7f269e29ded"
    sha256 sonoma:        "1de9e56ab2f0e13cee24837aaf3598adb4cf5ffb9d033c0ead8158ea826ff32e"
    sha256 arm64_linux:   "d4adc09dec02c173463781d2f2bb4ce6ee6b1f7b713aa96fc63c7ee8698e9841"
    sha256 x86_64_linux:  "9bf5ac354fc76099c2befbe604b279be6f8538bc0f8479ad0cf5807a107d7ba7"
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