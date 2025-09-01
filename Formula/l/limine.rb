class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://codeberg.org/Limine/Limine/releases/download/v9.6.5/limine-9.6.5.tar.gz"
  sha256 "777b5e156e9e48a1be54859bb8eb396bd7f4731bf616cb1ea647237e57bb126b"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "1f5f049ca75bb1d24570fc45c98e547331feea5d2535c9b6c900c79142918c22"
    sha256 arm64_sonoma:  "8ad67e5ce141e5514275ae764bfa3eaf95824199a05b10dc882b6743789501db"
    sha256 arm64_ventura: "638e220de5e6abe68b6c19d87c01da4691f46335b1e6f4d99ce974c26eb823d1"
    sha256 sonoma:        "d2afd9fe4e0ca34735a44dfdef39a98e477b1b36fb3c7b2e70102e2c995e64b5"
    sha256 ventura:       "ab0ab1a974c10c2c37f97163026234113e36fa417b7aa28f88f8b01220aa1062"
    sha256 arm64_linux:   "7cdcdced9d4c1e14498fbbcffc921579709285ac0cc8cb6a6c07d81cbb104ef0"
    sha256 x86_64_linux:  "e38b0a8039319ad8ff31a888089fa17bf3705f6694409064fefe26968f4715fb"
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