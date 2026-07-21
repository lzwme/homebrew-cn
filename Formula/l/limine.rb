class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://ghfast.top/https://github.com/Limine-Bootloader/Limine/releases/download/v12.5.1/limine-12.5.1.tar.gz"
  sha256 "686771f88ca7ad506d23767966273f7b969535641e005b315ebf318c85753133"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9353e830d25616a40d7b43e60c24e52cbd49353f0e7f7dac4fc491d660eb0981"
    sha256 arm64_sequoia: "5d93ac35880f7edb3bada0a945d6212f10f2fab7cee193d45ea98e563c9f60b0"
    sha256 arm64_sonoma:  "ecd87f5130cfafe0f9d5311947617d10d1e9b8b483907c21d7859fa20aba016a"
    sha256 sonoma:        "3697694045381c396aa9a54a1bb8125b8f275e5dc75639592470333746d687ac"
    sha256 arm64_linux:   "e597c14f3037bd9e0abce75a73b570e51a4a683596e12c360bf3ad3b7d59c377"
    sha256 x86_64_linux:  "aa3098304e45d7d4b00c62353d99a5cfed7a85ef0f4ff14d2808a6fcdafefd94"
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