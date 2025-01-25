class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250120.tar.gz"
  sha256 "c0a5549b132fe38580e7bdd3bf4ef6d96164e176d1ac3e7a32522ff0d32643a2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f33c7a05085c2541fb9898c1ec049b68949ce30625163cba9f4044ac782bf49e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d96866ab701a8d54d76d931d203a903e457181b2347f73e095442ae343475a90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "070eff467ec6246ae7b4211b8ffae523f47b8e9125164946307e749b15a8d4bf"
    sha256                               sonoma:        "77cb236fa8c87eb46a7014546fbbef01eeba7a2c758d4c4b32a83df033fe98e9"
    sha256                               ventura:       "87b511ccfed9ae54d7fe21f2ef2a9639263f9c4e820ce0a9141c8577d7da6233"
    sha256                               x86_64_linux:  "2270ba7898f6fe93b2039c552b81ee886aca2f2c56778257d13d5c9efe6fa495"
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