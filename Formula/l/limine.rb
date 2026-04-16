class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v11.3.1/limine-11.3.1.tar.gz"
  sha256 "eefb2ddf7472027eaad2d24d2ef9ab12281514cf9ec546a3e3a759df2d8654e7"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7823620f664b4f158132b74cfb32b1bebc21a4307bf4fe6cd9af858706022d2e"
    sha256 arm64_sequoia: "a8d19949e1f11f99e6659315c268bba20c507bbc2c71d4e7cdd33291ddf8950a"
    sha256 arm64_sonoma:  "3ab97d5abd7d84b3627227d06ea68fd04835cf1cb40a20f07a4f4b644ef5e8e9"
    sha256 sonoma:        "4ecb067137f53ff42765c1e3b620e2e725901b1b7a19a4d45a09db1e1ae1ff1e"
    sha256 arm64_linux:   "43a97fcbbf88fe5ec40b2d0a840d08031b86c125af04312fb78f97dcd9f4bebe"
    sha256 x86_64_linux:  "cd5fdc6293b1b1d7721c70544a21840786274c15260dbc5f251521145ce47e92"
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