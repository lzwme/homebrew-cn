class Libisofs < Formula
  desc "Library to create an ISO-9660 filesystem with various extensions"
  homepage "https://dev.lovelyhq.com/libburnia/libisofs"
  license "GPL-2.0-or-later"

  stable do
    url "https://files.libburnia-project.org/releases/libisofs-1.5.6.pl01.tar.gz"
    version "1.5.6.pl01"
    sha256 "ac1fd338d641744ca1fb1567917188b79bc8c2506832dd56885fec98656b9f25"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url "https://files.libburnia-project.org/releases/"
    regex(/href=.*?libisofs[._-]v?(\d+(?:\.\d+)+(?:[._-]pl\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91745e9aaaf63e3aa7091f09d06b334dde568da0e517c476d12d436231929b8e"
    sha256 cellar: :any,                 arm64_sequoia: "dde88abfa9bf4de11ff3651116092d3e48ed73a4edde2b06a5f18f58c237d2b2"
    sha256 cellar: :any,                 arm64_sonoma:  "b87c10636af673e4955f45e59c84bc59006f95164901523a2b1949ddcbfc7f5e"
    sha256 cellar: :any,                 sonoma:        "b718bf4b7ea56c1e064e538a97b46c81e32f97e9dbc604c0e514efe584ba2b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d06187d556a812c2ee1de797cabbb570132ef12f10f58d50fd652ab1e7ec634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c62d9f3b97f96ff2cdc2867372690016c4b2e07adb3d20da58bfda08b40ea9e9"
  end

  head do
    url "https://dev.lovelyhq.com/libburnia/libisofs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libzip"

  uses_from_macos "zlib"

  def install
    if build.head?
      # use gnu libtool instead of apple libtool
      inreplace "bootstrap", "libtool", "glibtool"
      # regenerate configure as release uses old version of libtool
      # which causes flat_namespace
      system "./bootstrap"
    end

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <libisofs/libisofs.h>

      int main() {
        int major, minor, micro;
        iso_lib_version(&major, &minor, &micro);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lisofs", "-o", "test"
    system "./test"
  end
end