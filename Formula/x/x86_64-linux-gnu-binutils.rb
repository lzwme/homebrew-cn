class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "4b280edb9c59a8f2b5505719353fbe526f1f5505a50e0b4d9461c8bed065a919"
    sha256 arm64_sequoia: "8e42ed55693262acaa7d041dfa5c804a2aeefe2946294a84e706c433934c1aa6"
    sha256 arm64_sonoma:  "968e41c912fcb9b9507ad3a16468940e4875b00fe35d4dea02cf88108bac1412"
    sha256 sonoma:        "8ef1d5f4bedf72f2d1931971494950ceb55fda4bcf5db8045afad7b1e68f28b8"
    sha256 arm64_linux:   "6af499ae4fd08dbd3917733ce01fa4aa73931854c1cdb0a236369f05fe03bc0d"
    sha256 x86_64_linux:  "18fee2bdbfa6f1f9179d4b281de07c3ba9eff4c0359674e6aa4533e2ea5e3de2"
  end

  depends_on "pkgconf" => :build
  # Requires the <uchar.h> header
  # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
  depends_on macos: :ventura
  depends_on "zstd"

  uses_from_macos "llvm" => :test

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"

    on_intel do
      keg_only "it conflicts with `binutils`"
    end
  end

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    target = "x86_64-linux-gnu"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib/target}",
                          "--infodir=#{info/target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls",
                          "--disable-gprofng" # Fails to build on Linux
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-sysroot" do
      url "https://commondatastorage.googleapis.com/chrome-linux-sysroot/toolchain/2028cdaf24259d23adcff95393b8cc4f0eef714b/debian_bullseye_amd64_sysroot.tar.xz"
      sha256 "1be60e7c456abc590a613c64fab4eac7632c81ec6f22734a61b53669a4407346"
    end

    assert_match "f()", shell_output("#{bin}/x86_64-linux-gnu-c++filt _Z1fv")

    (testpath/"sysroot").install resource("homebrew-sysroot")
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() { printf("hello!\\n"); }
    C

    ENV.clang
    ENV.remove_macosxsdk if OS.mac?
    system ENV.cc, "-v", "--target=x86_64-pc-linux-gnu", "--sysroot=#{testpath}/sysroot", "-c", "hello.c"
    assert_match "main", shell_output("#{bin}/x86_64-linux-gnu-nm hello.o")

    system ENV.cc, "-v", "--target=x86_64-pc-linux-gnu", "--sysroot=#{testpath}/sysroot",
                   "-fuse-ld=#{bin}/x86_64-linux-gnu-ld", "hello.o", "-o", "hello"
    file_output = shell_output("file ./hello")
    assert_match "ELF", file_output
    assert_match "x86-64", file_output
    assert_match "libc.so", shell_output("#{bin}/x86_64-linux-gnu-readelf -d ./hello")
    system bin/"x86_64-linux-gnu-strip", "./hello"
  end
end