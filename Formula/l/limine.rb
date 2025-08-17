class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://ghfast.top/https://github.com/limine-bootloader/limine/releases/download/v9.6.1/limine-9.6.1.tar.gz"
  sha256 "fc601e671d9286d0be568a8d3bf481f07e242cb81d2c073f440195c45e8899b7"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "caf878d72bbf94b1a28fcddc6b6ba872706a2caeecc0893857c7d5dcecacbbc9"
    sha256 arm64_sonoma:  "83efc6bf1d9e157ec60c0f44d3f35bd2a8cc1154522e18bf684882d6ca7c7750"
    sha256 arm64_ventura: "796635d212764907c095db379d794c07d1cc7df053cae58d430a9772edce2bcc"
    sha256 sonoma:        "77fcb7dcaf579f91b338e5f691e96b6d26e4dada722db7470810678a562534a9"
    sha256 ventura:       "63d866853e3a42e81cc65011730e9f378fa29343ebb32acd6f8d43d060c7da26"
    sha256 arm64_linux:   "dc500f5149014d2f5d14b53e33865691f583bacb78e62c2397ed306f46dddd1c"
    sha256 x86_64_linux:  "1a428b6b0900945e3c10b4668a1a06c0c03dc97b477e7049385fe08aafc85391"
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

    system "./configure", *std_configure_args, "--enable-all"
    system "make",
           "TOOLCHAIN_FOR_TARGET=#{llvm_bins}/llvm-",
           "CC_FOR_TARGET=#{llvm_bins}/clang",
           "LD_FOR_TARGET=ld.lld"
    system "make", "install"
  end

  test do
    bytes = 8 * 1024 * 1024 # 8M in bytes
    (testpath/"test.img").write("\0" * bytes)
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1")
    assert_match "installed successfully", output
  end
end