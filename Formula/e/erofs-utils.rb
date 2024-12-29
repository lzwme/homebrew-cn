class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.3.tar.gz"
  sha256 "3c5cc03603ea08ba9ae5e0420eeaea5ff17ed29e2280685310356cbf25304e85"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1106a4906f31557bb358b77d1c51b5905fff689717c5eeedd47f82967b406985"
    sha256 cellar: :any,                 arm64_sonoma:  "adbacd3f9845bc5d770a90756bcf978114f8439f5c32b0f77afb68eed0932b5b"
    sha256 cellar: :any,                 arm64_ventura: "d1f7c3cf63659a85de11d714077dbb82bf240034aa31d910d02a499bfaac40f9"
    sha256 cellar: :any,                 sonoma:        "c8f9bd5545b11ac4a3a24657b6a12a6cb0a2440ee09879390e1fbe66ac2579fa"
    sha256 cellar: :any,                 ventura:       "b1f8f93404625ef5e4d2027ebd3223f46e291ddb39d8b9bd5b6c719d91ca891e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "922c1654f86ab24490ec60f8ebaeb48744fc10f20647d031249e470e8b211721"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libfuse"
    depends_on "util-linux" # for libuuid
  end

  def install
    # Link to liblzma from brew rather than system
    ENV.append "LDFLAGS", "-L#{Formula["xz"].opt_lib}"

    args = %w[
      --disable-silent-rules
      --enable-lz4
      --enable-lzma
      --without-selinux
    ]

    # Enable erofsfuse only on Linux
    args << if OS.linux?
      "--enable-fuse"
    else
      "--disable-fuse"
    end

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"in/test1").write "G'day!"
    (testpath/"in/test2").write "Bonjour!"
    (testpath/"in/test3").write "Moien!"

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lz4` support is properly linked.)
    system bin/"mkfs.erofs", "--quiet", "-zlz4", "test.lz4.erofs", "in"
    assert_path_exists testpath/"test.lz4.erofs"

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lzma` support is properly linked.)
    system bin/"mkfs.erofs", "--quiet", "-zlzma", "test.lzma.erofs", "in"
    assert_path_exists testpath/"test.lzma.erofs"

    # Unfortunately, fsck.erofs doesn't support extraction for now, and
    # erofsfuse doesn't officially work on MacOS
  end
end