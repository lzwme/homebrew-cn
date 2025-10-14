class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.1.1/limine-10.1.1.tar.gz"
  sha256 "a43840f0dedae5c4e8ac85bc3a00a298ec717d9dac954869dcaf9c6fc2880337"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "39e49d8d8887664e3a805501f299ec7640541f5b4e72239a4aa369e4bed37eb9"
    sha256 arm64_sequoia: "62f2ee0deababd4d89a83c3dd3a8f6282e288c6ec949401762c355139c20192c"
    sha256 arm64_sonoma:  "52cb925fae0a31c83e64f07ae7bcbcf89f981188d93564cee6c1440ae8b01e36"
    sha256 sonoma:        "4ad9eb86f0e9f8ffe98f97f53a367753d0012aefd271ae3e919be59c598ebd08"
    sha256 arm64_linux:   "73ef3b63dcf8960044cf37b696bd7b4db6ebd7fa2a3a465486f04a9d85c5e50b"
    sha256 x86_64_linux:  "849fb2cdb5916d48b0f0ab098b626cb7794783fc75766c5f7c28b782ac413704"
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