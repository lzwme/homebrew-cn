class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.3.0/limine-12.3.0.tar.gz"
  sha256 "de532a72c082d233ff50c917b1cb103d08e52faae4b89e964491695d9fac243c"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "83a4f4f06c206b9f771a18966c94574b236705cb938dc41917d9dc8cfc4d3ce0"
    sha256 arm64_sequoia: "5529530efee518a27c3465f750ed4bd23f42d0f5bb78da9619b585a6f2b49fd4"
    sha256 arm64_sonoma:  "3e2b336d3a39592c94cc131495617cc0ca5d3ea7d908ceab6436060be44d0370"
    sha256 sonoma:        "fbeccea161712d832c0339e533ed2d9fc39e2cb55cda30499c63e77a900255f6"
    sha256 arm64_linux:   "edcd093d4f23443701e064da4f710753c22ffbf7b4da10040175b5f400e04813"
    sha256 x86_64_linux:  "68511d258630e771ceb962d7e56e0be8825c8e858b8d66c723bc61aad2f50141"
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