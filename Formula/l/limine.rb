class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.2.0/limine-10.2.0.tar.gz"
  sha256 "78aa0a8d127e25b6b0b9c61736f62b44cb647726e7c41dc6d7193feca4786122"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3ae0b1368bc1f2a9da5140af2310a8eaabca91727d319c176038d14f9342d728"
    sha256 arm64_sequoia: "8c852b5d294238e5cdc33df01098566c74914b9bb6446127c70cd116f9d6c99d"
    sha256 arm64_sonoma:  "7b19b93746b55b1e3363981d13c443956cd27ce43f8d43f0d1264f43a074272e"
    sha256 sonoma:        "7b4f1a5ba329b5739fbb3b0169508ce2de0c74ace624e4b7a9ab24b333b6791c"
    sha256 arm64_linux:   "5da96d11c638f0cd99dc43bcbe89e526844a7f3f67f85af04535fc69fb4c1cdf"
    sha256 x86_64_linux:  "8584f8e12255ed49f52e64655380fe89999cfb56e47b01c1efb7fb2b168b921c"
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