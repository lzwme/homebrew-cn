class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.6.0/limine-10.6.0.tar.gz"
  sha256 "acd2cf7c31d85463b33bba67bfbc3e97c91ebe628f1452773b932d3cde98946e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c1e0ed63097d182c6c5344de1fbc6c0c6e731e484567748a47e774a00c16ec0b"
    sha256 arm64_sequoia: "b2d1057cfb47ea37897055dcf81030aa3f89964b226e1c6fa3f79a8b278c2dab"
    sha256 arm64_sonoma:  "c4429c0b18a1f0701fc66a4e83e19f8a2e3b04a2f2473f7357c238f2f195ae5e"
    sha256 sonoma:        "037b530bd744a5684df1eae6fd41bb6fc26eae0b1393a52800b8e254a0fe9b51"
    sha256 arm64_linux:   "8a9426bbbde2d13737cb080fbdea02161a36ee5d0c2ff7704f533b029bff33f6"
    sha256 x86_64_linux:  "cb15ef074b7b3dae44aee3075a077e4fd9bd2187f0be57bffde7d50de5679755"
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