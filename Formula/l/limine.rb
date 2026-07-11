class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.4.2/limine-12.4.2.tar.gz"
  sha256 "9ab373f389caa9e63dc298a7b45af5351ac9a4d00f804f68c1cba619865cdade"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a659fd8ac005e5a33cdc18534a1487753d873d31718ba2a2e0796b28e6d4dd90"
    sha256 arm64_sequoia: "fd2a5a5e5eefd1cc14f7cdee67d60e4463a6df6ae083fe5cae0e8a30c35a4b62"
    sha256 arm64_sonoma:  "06c1ddce53b705d09b214b9196a6270b970ec6766cbe2b8bdde124eb01fac494"
    sha256 sonoma:        "fb6d09f09d90999cdff91d5187bf1ffbe377c733b3c732267e70dfdf97519ea9"
    sha256 arm64_linux:   "57c0364ac9b80d58bd9816b9d33c0f029a1001fdb19581b2eb9b595f23128b64"
    sha256 x86_64_linux:  "ff345076c03c963593809719f7f2eb001c2b85ba93de1ee6bdfef4ac622b0370"
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
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1")
    assert_match "installed successfully", output
  end
end