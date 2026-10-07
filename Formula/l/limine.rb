class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.9.3/limine-12.9.3.tar.gz"
  sha256 "b28b9c9f614f4252cae79580d6cbbc09f4d764a541ec01d586b5c385e3776c99"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a10f00a148c40879c5d903e85dfeac0e1fb498034577c09c9ee4a285f212dd5f"
    sha256 arm64_tahoe:       "27bb0528f1aee4d728014a1b7c0c75eac2c0ab4453d42d3fc09d80d6e6528860"
    sha256 arm64_sequoia:     "3fdeec8af27f6dfe129bb2c4ca55a048d38ee3e81dd3c9a6e4849e68a4d64ddb"
    sha256 arm64_linux:       "94929b6c73ae96c85bd98115e8c6b8894534c3aafee1c27361dc092e7199afda"
    sha256 x86_64_linux:      "7541b1a7d6bbf28cd2ad59bb9d089144388aba9b633a3de8b389b13a4831d2f5"
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