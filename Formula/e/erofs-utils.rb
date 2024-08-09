class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.tar.gz"
  sha256 "117f9e5d9411e8188abb6bf77d9fa967291f60a9ee65f3dcb8e9f88e5307afdf"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d9c757591df0def9049ed729ed0a403382daee6ac1c301c525813ebf732a5f0"
    sha256 cellar: :any,                 arm64_ventura:  "cc9e974a4628f406970cf53442a2d8c4816d634f5aa43c224185738c9d0f8bb9"
    sha256 cellar: :any,                 arm64_monterey: "d9c5d0ff3daccc395bd0b033c848a1aeb302ea602cbc96438680657e1a8f0c7f"
    sha256 cellar: :any,                 sonoma:         "1223cb4ca2072d33ae8de6cc93be116799665b549aecc3a9a364ba08ec805a17"
    sha256 cellar: :any,                 ventura:        "bd8e0e3807809853bc9afc3d520e1a55b350f4f609131b29194102f3e35d6352"
    sha256 cellar: :any,                 monterey:       "441836f685500f7ac0d858ec89b68365b21b4a06e16d26510756b00659cf4246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d55a6b68666ee2e3290f4128ba1cd398d43ffdb40d18342d3d7d4f9bceb7c309"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "util-linux" # for libuuid
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "./autogen.sh"
    args = std_configure_args + %w[
      --disable-silent-rules
      --enable-lz4
      --enable-lzma
      --without-selinux
    ]

    # Enable erofsfuse only on Linux for now
    args << if OS.linux?
      "--enable-fuse"
    else
      "--disable-fuse"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"in/test1").write "G'day!"
    (testpath/"in/test2").write "Bonjour!"
    (testpath/"in/test3").write "Moien!"

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lz4` support is properly linked.)
    system bin/"mkfs.erofs", "--quiet", "-zlz4", "test.lz4.erofs", "in"
    assert_predicate testpath/"test.lz4.erofs", :exist?

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lzma` support is properly linked.)
    system bin/"mkfs.erofs", "--quiet", "-zlzma", "test.lzma.erofs", "in"
    assert_predicate testpath/"test.lzma.erofs", :exist?

    # Unfortunately, fsck.erofs doesn't support extraction for now, and
    # erofsfuse doesn't officially work on MacOS
  end
end