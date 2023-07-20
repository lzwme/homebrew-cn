class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230711.tar.gz"
  sha256 "0a81542c03f1a0e6c27bf5015d8fbbc52634e1190838ec7da7645847d9332fef"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89ac9a5689c2130218c5d2933a71b8dd12a4a6a61922acc25fc8bfce5740232f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8b826eb461c4f053570fb3a7ed4f624bd0d33f09d21f25be3f50f492217589a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c3b96750b6920cf9f4872b41b3758c3d3a660a83909aaaf8f919fd43381dcb2"
    sha256                               ventura:        "48dfed468a1bce48d6ec18212d1400fa753d3ced982b445d24633c91117a80c7"
    sha256                               monterey:       "ddfe11196f9899a375cd88d9314a25c1a18121b05c116b15cf69fb5db8172518"
    sha256                               big_sur:        "40917155b29a0c05d3ef907f8031ea1320f01928768b0337cf6698c7ca6d5c0f"
    sha256                               x86_64_linux:   "b3618068094d7b7b61dfa7929e08153cc8b1695c1c01e65b6b2a05199a4c68ee"
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end