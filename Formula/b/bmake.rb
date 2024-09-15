class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240901.tar.gz"
  sha256 "b5d753befc42e8a852a38e5cb6137c4e5a91585a6cb3888cf0645725c7759a66"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c077caac473d4275a6f9409e8ea5dbb172701f80062185c94b9255d6ccfd434e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db0e1d8037a1735dae31d5224428221245723c4a492b470d31a7b0aee16633ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cebf42a361c1529a4dcf4ef81acd7082a26f17577354aa477930cdd83f64fc13"
    sha256                               sonoma:        "bf9fb05fe316bdc70efa1369a4dadb35cd8aeaa66f85bcd02b7c5717aa4de8cc"
    sha256                               ventura:       "99a5f01ddd8967196b3bf63839f32bf93c2e8c0366fe5d3e0a776cec94c63a83"
    sha256                               x86_64_linux:  "28d66dd80285a857d9cc5ae34b49e92a2fa17ecd06b7aee73d7ba6a06030c74b"
  end

  uses_from_macos "bc" => :build

  def install
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