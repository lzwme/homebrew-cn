class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://codeberg.org/Limine/Limine/releases/download/v9.6.6/limine-9.6.6.tar.gz"
  sha256 "d8d130982efe09b476f7b56c8d34a0bb362e8711eff18b4282d078a13ac4694f"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "42a66f8fb1f6b5af129abb0866da37c5f5f8a2cc2c13666127f9c3e7eed63be7"
    sha256 arm64_sonoma:  "1cace30ae8c4fadbf7e6d6b2b7a18a592e84f6398a6520469ba3bbc6380d42c2"
    sha256 arm64_ventura: "c6dc0a98b29011570a8687062660769bb0dcfffaf2dc974a037ffc6ee3a3ab5e"
    sha256 sonoma:        "453e15e7f7a14d6949aa269555c693f1c4d4d5564e4758df10e5e9bb41c969a2"
    sha256 ventura:       "6d334837ca8f76aa0854556d234e4a531305df0ea351ee8b9877cd898bbd832b"
    sha256 arm64_linux:   "1ff5add6987794a573661732f644756e6de444768f21d3fece3ad9eac6a1687b"
    sha256 x86_64_linux:  "3ab06737562f4f67d5940141124822cea7f029426fa8694f4be0a5d932d11c84"
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