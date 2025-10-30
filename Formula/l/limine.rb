class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.2.1/limine-10.2.1.tar.gz"
  sha256 "b7db8d29b24a53daafc7d2c9442c8301e2de2260cc07197a9b5dd542df04e816"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c139e0e9afedd5635102761a29f24c73ae2195281c47b771d003df95f7337095"
    sha256 arm64_sequoia: "d4fe9c754b5a77485b87dd5191dddf0255e04d6e1b199fb4c38c9df0e36eb567"
    sha256 arm64_sonoma:  "0ec68ad6ed9b8af1f4a01123bac1cfd13658f34675ba9daf066a0f3b41461df7"
    sha256 sonoma:        "70535c80b8841b1fd34bbebfc7f9bdc1091488e71e089a2bc5cd89b6b83b8314"
    sha256 arm64_linux:   "4630812ecc519b61f3528e7e907c8845fd4b014dfff471fad4c996fa3680e1ed"
    sha256 x86_64_linux:  "7cf5d7859d31a66da38e032af67e26008b6397c86fc023a6eb216b4c32700edd"
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