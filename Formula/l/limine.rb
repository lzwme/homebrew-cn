class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.8.3/limine-10.8.3.tar.gz"
  sha256 "e8c025b293f03c87476e100e3ee7d401272444572e040d9ce87c322b0f03429a"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2a02c939c7e87b6cf5387900c0febcc4b89412e9415afc2c9c5d75f33e920268"
    sha256 arm64_sequoia: "0758884cc6ac42df21a057e4dc503bd77539ce89209b28e4d3ff6862f4873286"
    sha256 arm64_sonoma:  "79b7c63be71301cbef2ff5437e51235428dc9578e16caed5a72d1bc37d4d4700"
    sha256 sonoma:        "e5969fc9dfe1f72baa5c48a67f886f4cbe7d2eabe38354b827c3536b28887a0b"
    sha256 arm64_linux:   "6cecf5739576dcef982d5f84f5f7b4b0d0d581385a4c05677458bd8d9d018c5b"
    sha256 x86_64_linux:  "6091d52c5a0d4a574d1725f5d5aa76b1bdc97ed8f55a1daad0591954318f93f8"
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