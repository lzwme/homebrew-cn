class Libisofs < Formula
  desc "Library to create an ISO-9660 filesystem with various extensions"
  homepage "https://dev.lovelyhq.com/libburnia/libisofs"
  license "GPL-2.0-or-later"

  stable do
    url "https://files.libburnia-project.org/releases/libisofs-1.5.8.tar.gz"
    sha256 "910532653e6a56b5e4c2ef8717500d913debd5fd29f616fed15134b7522059a6"

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
    sha256 cellar: :any,                 arm64_tahoe:   "7aa1c6b0014287eeb32e00df255d513edbb924f27ac4211f6a43e740af5e0ab1"
    sha256 cellar: :any,                 arm64_sequoia: "6599e191c4349560c2cfa69fac3366517e9a4b9e4210940657717812147c9cd5"
    sha256 cellar: :any,                 arm64_sonoma:  "1e6c244eb84c438601a29b21eb50bec77c44e5940a248f0ad24179d5d8833fb0"
    sha256 cellar: :any,                 sonoma:        "13bfe4b276b3a352354364e99cc5f009cf8286e362d1575bdd24af551330e556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "429afaf2deeeb76cc4e42d3d6e5e743955c4261984f9807592150e88f0967a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f4c52c8c9655e6310ab81fe2c14669a7cd24e928ec0211ff1616e678d487e47"
  end

  head do
    url "https://dev.lovelyhq.com/libburnia/libisofs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libzip"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

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