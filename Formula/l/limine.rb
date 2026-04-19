class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v11.4.0/limine-11.4.0.tar.gz"
  sha256 "d991198103f39e1ec1bc4e4e2f19e8ff8687e3db73304ddf7ee38434a43c21a0"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e614e700e9cbb4d20d71f8eb7f85346bee240df3bf54fcf4d92fb7a81f2c22cb"
    sha256 arm64_sequoia: "a1b9fba3f287a9068852cb13483ab4e02c17a4cc97e218f4df7494ae6a113284"
    sha256 arm64_sonoma:  "3a2acbd15ef9b3027d334cf55688e31a66996ee970ec3b728f10c976bfca3503"
    sha256 sonoma:        "b44241de2616e5de18f9885faa74234e27d1a893cc0e35869403973af676ceac"
    sha256 arm64_linux:   "c267492ddc0354d91f53b4a7292f98989daaaf3985597cc1225de9fce0f07048"
    sha256 x86_64_linux:  "3f63de3817cba5a3799a35da7ae75955ce3f588e59c5a4156b7e23e3f01c5cbe"
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