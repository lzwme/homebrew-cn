class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.9.3.tar.gz"
  sha256 "17bfa54f4d370838c61081fce44022815a0366e282d777389589184414d5adc5"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "85ddf93332ab17afbcd5bb97987100d12491bb64a72f937b3fe27e46b8d6c440"
    sha256 cellar: :any, arm64_sequoia: "b20df61c8934c9ea8437494180ddd371727f2a845b50a009e0ae30d3bc487c3f"
    sha256 cellar: :any, arm64_sonoma:  "3a2cee1fbe5f1fd6798938e3c526648fa0fe6986e92603840b8df5f723c762e0"
    sha256 cellar: :any, sonoma:        "5f61bb68f0c97280529ac777ffbfdb7749c3f6a83edfd285d04751f07c763cf4"
    sha256 cellar: :any, arm64_linux:   "a54720f25c91e85ed5ad6c013c985c00dee4926386dc6ae4e35bf509034bd485"
    sha256 cellar: :any, x86_64_linux:  "27d3ba6cbfec33e60d3c79b73c883d6ec77c1a7e22f4d98aa3e6eb5f856de032"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "xz"

  on_linux do
    depends_on "libfuse"
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def install
    # Link to liblzma from brew rather than system
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("xz")}"

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