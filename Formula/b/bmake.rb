class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250308.tar.gz"
  sha256 "2388d9fb186576633aa725ff163552a5dba7a6a375a8cb9a9014ab57ee7d99a2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48956339059702684fe97011efa598b5c792aca1cad4b6ecd291af445a8a5f24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82c5dcb087b8e1d6c13108cc76e608512c3b5ca421e171b3d8e01061ac3165ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79919fd51552c9f6ca2f10309b568c83ce39c78e2730350e957ec2dab9278867"
    sha256                               sonoma:        "7dae06e231f9a68129cb8d7738472088ab225a88d9e00a51de0170fd67a95350"
    sha256                               ventura:       "bb788f4ed929c149f3877f44333951d5568a75b97872122db701e2612ad399bc"
    sha256                               arm64_linux:   "359aa8833e7b378a7a5577852bd95ef611d2eb9a3bd3ebde1130ec05193bd4dd"
    sha256                               x86_64_linux:  "c1d7848c1744288e1f511f8c905d400d9669e0f8fc40c79b48c269af3eff2798"
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
    (testpath/"Makefile").write <<~MAKE
      all: hello

      hello:
      	@echo 'Test successful.'

      clean:
      	rm -rf Makefile
    MAKE
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end