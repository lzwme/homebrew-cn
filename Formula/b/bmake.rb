class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240722.tar.gz"
  sha256 "1654bd0cad284360849669a1e9a993181fed137896aac2694b82ea9a35f709e4"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af1e79db54760f607a6c01c1735118d57c7af87c10f3f1772b8035cb7516f956"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3dcc20c797ed83ff8539b8125cf76a2bada72d954418b1ad2dc3062c429d4f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81c607b4496838b9d5f38bcf20fe20da2c2ed7ca348b269384912cd695cac2fb"
    sha256                               sonoma:         "9d75718fc604b98956cfbc3a08ba962a871b8fe2a4b4ef70df757968e796419d"
    sha256                               ventura:        "c3e880a25a30b429f6f26719ee315c734f2f344d506a1f6404e07d90506cf9a1"
    sha256                               monterey:       "f2320da1017d6cef946a614b84126725ccdcef395868c6e59e1b1fcd62119781"
    sha256                               x86_64_linux:   "8a7911a475a76746c379376dbce64c51a399d16ce9f8961ce9dc2b5bb81bccaa"
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