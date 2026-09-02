class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.7.0/limine-12.7.0.tar.gz"
  sha256 "9ee9f5203761f511340f1ed11baa9aa865266bb65725009dc6d2d8828ff70312"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "edbd6d608ab7b3ab0c96e3362ae93f4811c172c39687e25c93c85648b47b0415"
    sha256 arm64_sequoia: "8d02c23d2ea559a49f24b430b0ab5d03745412380d759caf0cd3b14910ed8b2f"
    sha256 arm64_sonoma:  "5161b01c8acb53c0ace56956fcf0155bf65b87a013e7198cdb9d3feab519b5d2"
    sha256 arm64_linux:   "b8eed3bb2e2ca11c938710fd424b9de00b39f67b319bdbfe77ea6a621e0c1693"
    sha256 x86_64_linux:  "d24cbd8523f3ab27a517a668136e6f34fb61cf05e33cb5800ee3541b31b6a929"
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