class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.1.0/limine-12.1.0.tar.gz"
  sha256 "0dc54bed26042192a063f4d3b17f265bac23022b6e085f9e05e212b7a80c6619"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "64fcb2d5c5a6ec06dbc7d0a79ff7ae17bfae4b94dc35482c0c9418407146622d"
    sha256 arm64_sequoia: "fdee120171976128485425f9a72f0079694d6987bd13828d9c0a17ad1808864e"
    sha256 arm64_sonoma:  "dc8fd484e0f1a6352ed23237a91033c43cab9b94aaaad1dd56f1ebb1d82dfef2"
    sha256 sonoma:        "a75ad04d702f8ad38d31d32bd5564c8407814c54022c53a126fe6bd3f07bb843"
    sha256 arm64_linux:   "7415b22eae6337115bf85cc83181a7683ef6e063ccbc32bd9439aa4cae540ef3"
    sha256 x86_64_linux:  "43d6ac8e1de61123927501c2299dd1040879be8c34489f52fee67e80b6e12472"
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