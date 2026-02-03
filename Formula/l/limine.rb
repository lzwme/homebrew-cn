class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.6.4/limine-10.6.4.tar.gz"
  sha256 "9b120f37e6af0d4eaf01def6997e0814e2a3ed0905710fcbe2371e46444f22fc"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "64c0fd94ffbc6effbb8928362d8005f811014c2d62e2c7a49611648a7bce06c2"
    sha256 arm64_sequoia: "52fc4352d6fcee3e5aa7cb7c4682a56925051323457980bbb038bc186beceeac"
    sha256 arm64_sonoma:  "e6623b8360027f0c9e23d3f1261e259706d0bce96a4dc8a08a8b7bb8dbf7d199"
    sha256 sonoma:        "25df1b8dbee05ca5adb8662a51491ca85703a3205a992bb51c23f901ad9b9b2e"
    sha256 arm64_linux:   "0a884a14987289f01a6c13bbb510a89849a4a692463b4d42fb80dea10b9f1822"
    sha256 x86_64_linux:  "08272b5376213deac0c902ab4126f8c8b5e2dd3f1a9f13a2a8d2e25e84834c07"
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