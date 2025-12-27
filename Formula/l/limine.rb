class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.5.1/limine-10.5.1.tar.gz"
  sha256 "b03e35410277cc60c78a7ca7963e65a59a0e3d53f2bad3022c39cd64d9adb472"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ab22bddd92845e0fafc069cf5b92cc9acdb902f659d7b98ce946c3f546be002d"
    sha256 arm64_sequoia: "267c880a0c8e8ded6ce76af079e5e2294d8fb478932f67cfa48c0ec4c81daaca"
    sha256 arm64_sonoma:  "533feb4220fb3ed4f3a5cb005813f0ad36296f8b4c3ddcc414a09a3f9152df78"
    sha256 sonoma:        "c482bdf83a67d2d71a51ca684b6f12b17fc72f3125e6db02ce33666d85ae8167"
    sha256 arm64_linux:   "d164632d09f262d553276d77f508c88e7a192f80112c6f59a3d4743731cc5a68"
    sha256 x86_64_linux:  "4a548083bfa7a5b672acdd88886564051102ad7072084ffd96f08de5596864ca"
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