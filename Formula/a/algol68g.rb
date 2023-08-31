class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.7.tar.gz"
  sha256 "ce15e1588b3a6f25bd7c33f79dca00e3ed47dda560c1c31dbc885a02776e17ae"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f27988ed5f2535c9368f8b55d2663eb416f9fa528f598d0c7b54f704f2b73c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6080a4fd3d0fc35be9602b7c033bba9c8909762e9329c6f1103895092656818e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00d82c5dcb9dcb754a0cf019c8f14fa8c88f2de62a87770ee5ca514641db1491"
    sha256                               ventura:        "576600f1daa73ca4fce81cd7b8e79bf042db99ce6c901d60de7b29e7f588d4cf"
    sha256                               monterey:       "2f55e6769950d0348fb9c32688421a2abd69d7fb24c2f9c28f58f9285fbc18e4"
    sha256                               big_sur:        "70d2555a93a5d81e5c65d9cc55db9e87fc560c31b350a2f930af4b57475aeff8"
    sha256                               x86_64_linux:   "bbf424e2fb440bc8a624877258f0b9df9360161558507d80f9f4dc073c25ca82"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end