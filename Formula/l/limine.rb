class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.8.4/limine-10.8.4.tar.gz"
  sha256 "de7f9ab4606ced9a433fe74bac7cfcfc4d2b7520316046a4cb46ffd889da23b8"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "616695de8d1e904506abcda6f9f061ce9ed4af7dc2c6cd2b6965af5215b5efb7"
    sha256 arm64_sequoia: "c20f0d29767d320a3caac0a774d65aea8248f5e4cf93fabaf8e75fe168987a5a"
    sha256 arm64_sonoma:  "bdacda4c24e9e2866058a31f6d04b7dfc4a020aa2a50ef124aca8126e0dfd76f"
    sha256 sonoma:        "267df730e789a2a3ee35781fb072561ce29a6784c3b23fec30be8af98dabed54"
    sha256 arm64_linux:   "c718fcf61def08101305ffddc317d70831e095e801044522a8a2fa178d28ff0f"
    sha256 x86_64_linux:  "7185b89f746ff136e58741a0045a22ffd6de4b0d05672b70ef466c2f1c6720f8"
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