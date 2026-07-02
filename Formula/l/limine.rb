class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.4.0/limine-12.4.0.tar.gz"
  sha256 "7c34d0b98f96621c8997902a3f86682754fb59780271adf9a571c0bfff028e50"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "81a9c445624372269d6bbb489a512c8e560a1a839a802199130cf4b46673f8f0"
    sha256 arm64_sequoia: "1ad95f713b3298401cf17fb6cd314491b0e888067f9cf9f411553f421807a385"
    sha256 arm64_sonoma:  "0b6d96931fa5292efd299184f75b2e6d2dd04539d0c2b53a122eb3c9bd0cd162"
    sha256 sonoma:        "ed2071fcf846f8d8eae579d3c8b3c4b4a318e6dac6366b09f08ed038f03ed8b2"
    sha256 arm64_linux:   "e6bc8085b2ae762b836c3d786045d3023ac4e3db58617e2417625b2a629a1155"
    sha256 x86_64_linux:  "1b3cb415507cd4fc4713af77b80d7326833ab26bd4c1e04473fa44bc571bf56a"
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
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1")
    assert_match "installed successfully", output
  end
end