class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230512.tar.gz"
  sha256 "b927b50a45e4b5579c6491ab09ce3dbd8b170fb10fe6f16d484e13d15e338ffa"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a79115200ef200edb08103c69e7644aec8dcc9c16a96b2bee670c2f3c33ee1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d60a9edb86ddbfa4ef3b5083aaf812b75dd616d7248dcde431942f9c4755c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57ddfbc9eb6a31d82e238f7ebbb44999b904cd928038a71151c5ec6f0b39ffcc"
    sha256                               ventura:        "65b3fe74cf6389ab0360ac95d2f81084c6154ea72bbfa382fbbac1520e394097"
    sha256                               monterey:       "5b6a3072749f0b8668b38ce72516a6cf0292b168e8500bd8a362fed641f5354c"
    sha256                               big_sur:        "d36b53e7cf2b9cae14524e364cc0d66dbc4c931798f97cc0a63dcf9f823a8755"
    sha256                               x86_64_linux:   "9537ba798737fdb53ffc70516dc3776eca63687b7b5c9f3c96729a8f2494ec14"
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