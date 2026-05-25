class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.3.1/limine-12.3.1.tar.gz"
  sha256 "a2b928b716eeb15e208a8cc32e4519b8b6401cd4b81999df8fe1178b9b524565"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "be65ca58c682fecb696c0f95a38b2f017865091ffcd37434415c33a5b4ff0dac"
    sha256 arm64_sequoia: "b9852b6e9792febbe478f96c128c3c320ae9b28134a62ee3529d580a32def0e3"
    sha256 arm64_sonoma:  "ace08e2b2b621a7ff7ce5b3baa880dac6313eb03aa6b6c93995e33157e1744dd"
    sha256 sonoma:        "54787c1360c84423df352d4be9405d781ff69ff4ea383069f06180d423c8fd80"
    sha256 arm64_linux:   "f3a19a25a9ac757c955c9dc6823195d4591e1ecf51af136236947f01ee73e6a3"
    sha256 x86_64_linux:  "2be801f979bad688357ceb60a9e68437e548d76dd7f157264a4cb45b5f4d6b00"
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