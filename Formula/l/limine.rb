class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://ghfast.top/https://github.com/limine-bootloader/limine/releases/download/v9.6.0/limine-9.6.0.tar.gz"
  sha256 "715f9b2d507cc06553e2127e5a45da41034bcd66a86663176b5a993da1990271"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "144a329e3cd4d0e04515411cfe951676061f8acc078ac154036dceea9419ccf2"
    sha256 arm64_sonoma:  "6edbf2f5f65a78498db4c7b8bf6b292e852c12979dcb6dba5e9a891249041bf9"
    sha256 arm64_ventura: "de3a113c1ee26a865a16f3e335f5b4a436b56ae0ac9dc4ef4028ede1e1302f2f"
    sha256 sonoma:        "c1f6f796490e0392521b7e17dca9fde88d587e7566f13d64d58b8122a8fd0216"
    sha256 ventura:       "55efe1a93768cddc8022c9d1357f0815a33ae7a9913bbe51bcf83a57dd90e3c9"
    sha256 arm64_linux:   "08f83de27f28ec02d1c8defd5bfcf6226a2e6fb2117a1cad50129d31439afa0c"
    sha256 x86_64_linux:  "2f97f997a36044836b008e87afa224d83da698805d602fd2894fccb13e552f34"
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

    system "./configure", *std_configure_args, "--enable-all"
    system "make",
           "TOOLCHAIN_FOR_TARGET=#{llvm_bins}/llvm-",
           "CC_FOR_TARGET=#{llvm_bins}/clang",
           "LD_FOR_TARGET=ld.lld"
    system "make", "install"
  end

  test do
    bytes = 8 * 1024 * 1024 # 8M in bytes
    (testpath/"test.img").write("\0" * bytes)
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1")
    assert_match "installed successfully", output
  end
end