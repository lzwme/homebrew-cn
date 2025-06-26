class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.8.tar.gz"
  sha256 "927dba9186227f5279ab49dd60bd58f3cecef40c36845acaf6f1ffd006a094f4"
  license "GPL-2.0-or-later"
  head "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  livecheck do
    url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/refs/"
    regex(/href=.*?erofs-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea5469d61a3b0ce1cc8281154c02c54080b1f9076b0712e23cf6f00115f6cc81"
    sha256 cellar: :any,                 arm64_sonoma:  "9da10827d7e0c56b72c411dbf3846293dd90aceaaae8be47d6a8339ef97f7cc5"
    sha256 cellar: :any,                 arm64_ventura: "77eaa517da8a816e94dace158c266172bdcf8962f78e3807c8378459de6646b9"
    sha256 cellar: :any,                 sonoma:        "af32cd518b222a674c1a30bac7ba8aee6191c2146be6a21ec09e655e4b4ba162"
    sha256 cellar: :any,                 ventura:       "617e9aa287787cd335f64126772a433ca7285421f6473f718189289bf2e26479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3ba85aed797d0f1cdc05039a4f5f1084790ecb4bdb9090f1ba343506db28166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59fe3b30de1abce4f65bd3653d5d3cdb1e70996f50e4dc16283bb3f622266968"
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