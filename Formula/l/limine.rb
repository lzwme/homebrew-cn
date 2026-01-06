class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.6.1/limine-10.6.1.tar.gz"
  sha256 "8ee0a2be02d5a4663b8621cb3216708534dc20f03609f6322874e9f0ecb7de62"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "295d7398fb0bff9c6c01fe171cf3c2aef7dcba9c6efbd93205a55a17e2235d40"
    sha256 arm64_sequoia: "f113132902d22a737cb0665b1efbba5475b05a066e57acbcdbf301ccbd42d0bc"
    sha256 arm64_sonoma:  "5642013c988b2b8868c8b94bb43909549e03d44b44dad26c2ef5d2d38d47f0cb"
    sha256 sonoma:        "85c4b2f9656c59d2a7a3f6a447ff3570b83ff0e15cccec47efc13b924077e3ac"
    sha256 arm64_linux:   "c6950fa776a836c2aab119a1a14003253cc29cc4165e7566d2bbc5140c0ee1f9"
    sha256 x86_64_linux:  "69ec694a2eaea4dfce42bd5f35b78233c5fe41ae17cc3ef00c9134b77bdc8d4b"
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