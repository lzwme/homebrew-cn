class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250707.tar.gz"
  sha256 "a61240a4065d90c3925dd774f8fa3d73deec1a73228a86ee95fcd82063d28b08"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8e82848e047e5539e3ec412684e0cbba00dd4ff8c5579729f73f53237b089c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d115e944a48b9d5f8e5e2c36edd3890de45212663f93a28d96eb0f6c3832ea25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a30dfc6b420ccc6e604da882c27d190b31ec3412568f8b77a3cf9d135c7e5642"
    sha256                               sonoma:        "5b164565bf2ba15e756b080be5952eec98eb2436c6b0b69e4ef85499250b64f1"
    sha256                               ventura:       "42da48271ac3b1168d5584f2ffb933d43eb2be9675c1a1465c032c8ff9f10803"
    sha256                               arm64_linux:   "30b324859f3975bfa207188a65ff53ba4123c4dec49fdad2068546d16adb6d2d"
    sha256                               x86_64_linux:  "d84e3eb1dc2135082002d53bdbe6e7fcbec86d492e9283f49eea52eb2aa8b3e6"
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