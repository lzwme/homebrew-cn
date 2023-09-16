class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.22.tar.gz"
  sha256 "7120fa967802cbb482d8fec6c9409a8e4ea2f3addadefbc28ed8192c5d13ac80"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6b444301800f6881a01281b7790971db1a3c36208a78fefe784f5aaa2c537d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39b502983adb3b19157adc1952162db99190de0df68c3f3b7d22a4537192914e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e23e9acf20b41166aee1981f7b8c20fdc7ba477f8b2882b50f99d44d809860cc"
    sha256                               ventura:        "4e9376f6ba7f4eb4755baa79fb3285a75c1d2a14eaae90a555998b3c327c7bb9"
    sha256                               monterey:       "a89d9b1cd22b78eee2dd50c76fc696b570de4a6df2a2397617bc944100d062a6"
    sha256                               big_sur:        "53cb51c6de26acc752287f3dec97451d77cb921dd8e278aaa20ee0dcfe6d5f94"
    sha256                               x86_64_linux:   "1e6da1c41ea4a34b6c784c5dac1e19de13da0cd7cab5dcb0e327a27d5997258d"
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