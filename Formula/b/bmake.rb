class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250330.tar.gz"
  sha256 "e012a34b0a8b4fe03ed4d0e2452580391c66a4076d7a0aa1016d2c0a096eb9b3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ab5b7f4c3fb3534dd1b8b44aede8008bb79620ede29210f547d20332976f2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5ff9baa16307fb1b0023709793204851f2f4024f361b1f7132795f6a65ac1f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5454cdd7debe58740e21ba937abef897628c858f7f41de66ab8a3fba9d09a9d"
    sha256                               sonoma:        "e429fb3ac381663f81aaac2058141ad51ff260764ba9a671d4234c95d2d337be"
    sha256                               ventura:       "77d88b39748362147cab75652e8651411cf5d0688bf9427c913558d316590d91"
    sha256                               arm64_linux:   "892560a0df7d6dae48a5408b899fa460dbfb1008d009c0ea2803ff34a1c4de25"
    sha256                               x86_64_linux:  "e2f028b092d6c6016bb77a93262cc51f43b20cb4c7fdfb1d5e72a54dc44e34b8"
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