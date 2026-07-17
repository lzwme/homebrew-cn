class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.5.0/limine-12.5.0.tar.gz"
  sha256 "53d5cb2772ea8a006e137ee2e320d84ef94ff7c57f880a640d1787d92e79fce7"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "32a4f90683afc40bc5050dc6dcffaea21a14d19a30a39b88729c0e23f681cc19"
    sha256 arm64_sequoia: "fb6e7c0f27c9ce38a1c527279ff593c1fe4675a593535aaa53eaf6ba04338fa9"
    sha256 arm64_sonoma:  "b7fd73f0010a617c0e993e6efb7824e4fa6fed77f23c90d5fdcf2fbae8770066"
    sha256 sonoma:        "d07afb9f0b95207ccd096c1c567a8fef3f938cfe5d339f7e73d18b27f58332c2"
    sha256 arm64_linux:   "cae7aa743f6de8cef943ceac6016315dd647e93d6481497fcef26772f063138a"
    sha256 x86_64_linux:  "fdda72ec254b481183e63d2247907bd6211fc9ee04610052c74d3cf0da1dd58d"
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