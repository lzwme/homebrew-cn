class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.10.tar.gz"
  sha256 "05eb4edebe11decce6ecb34e98d2f80c8cd283c2f2967d8ba7efd58418570514"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "972dcfa48a0ffa83cc603e1e360636fc3e3ebcd5d42b0e66b2a24ffcfe224e16"
    sha256 cellar: :any,                 arm64_sequoia: "74ef3476422c36f61fe5b2a1730cd6dbe64653ce16e1e4a19fbdfc9560531fde"
    sha256 cellar: :any,                 arm64_sonoma:  "64d735dfd268b12ded52b754358a793aa022e306a82e89876f4609235c85fdee"
    sha256 cellar: :any,                 sonoma:        "16b6b047443f4449fa83840950a9b1645a29520d2bd948a4a116ddb9459426e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f61e656f5cf40bd84158e1fa976e3a990b550f1640cacac8c802ecada017e1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a5e791f090e54d16e337f6698f38832255bc9c7cdba3315f28db654597f0dc"
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