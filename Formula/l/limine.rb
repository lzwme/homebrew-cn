class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.9.1/limine-12.9.1.tar.gz"
  sha256 "ee7c498670d0d16c897ecb391cd837cd375081cfd364bd3198db144c92aaccb4"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "339afa246218e3ec848437fd9b2b8436f98ee88dc068a2afd8cf229ea38a4260"
    sha256 arm64_tahoe:       "8e16ba5a432a6b3d4222155e402aa21e1533cde582599f9a3b7f5aad24b4d2e1"
    sha256 arm64_sequoia:     "9618d1e5452522893a1727b568d605fd031385556dc9b76494caed0a55b8a2be"
    sha256 arm64_linux:       "8ae959a32d0ca1575ae002f84058ca65283b6ecb65890fc35d4ad9c6c0078ed0"
    sha256 x86_64_linux:      "df30c9c3c083785e318f1fe797be12d5def83e57b531b73b541eded6b61ee81d"
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

  deny_network_access!

  def install
    # Work around configure misreading the space-padded output of macOS `od`
    # Remove in the next release
    # Ref: https://github.com/Homebrew/homebrew-core/pull/313773#issuecomment-5851072866
    inreplace "configure", '-N 1)"', "-N 1 | tr -d ' ')\""

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