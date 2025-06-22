class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.7.tar.gz"
  sha256 "d84941a83369a9128f2d57b3014aac86e63ca1ab03000a9f5bb21c703f10d272"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0158d7872fffdc11afce4b9936e725a7157090eeb2bba4cd17e91ac6ec303606"
    sha256 cellar: :any,                 arm64_sonoma:  "29efdcb10aa8fd8749a3211cbb90522d9668339e5c957874235f03a401ee0f64"
    sha256 cellar: :any,                 arm64_ventura: "307b8119bb0c10d5f5535e69e070b1c3c575c9a7b95f0710e01ab8126506552a"
    sha256 cellar: :any,                 sonoma:        "81a86dacf10f5e4c5b12bfd5544a4b909d2275b6086262ec7443f8eecca4b0c4"
    sha256 cellar: :any,                 ventura:       "763aecf4e56152b0fa7a1b9726c28e18c9e57c10184deb2f5f90f3031f9600fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "082e2e10e3c07b1fee4ab5af264ba58af10e23cf1c4b2e733f54059a26184ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669254ff1c836bf46a1e8a24edc5aba39db7d57d5e892945725421f03f8e10c7"
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