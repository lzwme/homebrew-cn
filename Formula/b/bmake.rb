class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20231124.tar.gz"
  sha256 "6453bde27880d384f20b9c3e05c33647e706d67ed385d48856783fb56120c530"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28d71e1e96e59bde437fd53b462b9021a31b4b8fe516f4e429ae6f7877ff297c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9b5de1d4eeb7dcafbb719108b01894138ed7de05aabfb44f4001995791ecfd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "506c992d64eb975254e141c331745e194ab8d7d9a937796b07cd0d11f832278f"
    sha256                               sonoma:         "ecf9663f114a42b7bf70922861a9dd0927a01fadc497b68d4d399475435ab269"
    sha256                               ventura:        "233d6ee2745f5120f684d8b62ea6134bbc809f38f4912f54018a75984aea01d0"
    sha256                               monterey:       "72e9f5b896726e993147f18367305abd71f2f847f1768733c65845a239842dd2"
    sha256                               x86_64_linux:   "7da1de4d692b3688a3347560c476048520056a0df813f2045c9daaeb7ded38d2"
  end

  uses_from_macos "bc" => :build

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