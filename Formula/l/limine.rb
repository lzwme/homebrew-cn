class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://codeberg.org/Limine/Limine/releases/download/v9.6.7/limine-9.6.7.tar.gz"
  sha256 "5469ff372f7054a055156ed23534f1faeeebaf9d7d8d0f82cdb719c134c12a9b"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "445cec31ba2f90ade17c22a1dd1f419d22c3f02677cdadbf82d226836995d314"
    sha256 arm64_sequoia: "d079f4f0474ab2b435fc46992d450cbe0595fd60ecebae2ad8308cc020a7b07d"
    sha256 arm64_sonoma:  "9a0e1ac7b93c0738abee1c87a6299e0cd14545e24dd60ed8d31c53f32e17341f"
    sha256 sonoma:        "4f016cd6dd62851872cb39924d52376154f63c639173c41b690cc0c3a4999be1"
    sha256 arm64_linux:   "300bd50b3a191c2738fd18a3d1f8305d8c014b507b41e01a04013c3e657ecb35"
    sha256 x86_64_linux:  "79d33f8ed421e69c286f083831024c5e9c34aa707314fc242909c3e198e6e1e6"
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