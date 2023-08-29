class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.3.6.tar.gz"
  sha256 "20739cba6062b133b862964c2d77bdc07bac7a307c650a0e00b9362f7f8b4057"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a58cee2f4c2b4463ec35b8cd46d31638d20f9eb6dabaa45191f73bbb81226cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8227a67cf008d154d3c6ab521fb7ec707fb47865680312e3c32cd854d7e701da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d456faf1758135c47f021e6e2353a0166380af08f34bdde330507b03cd2800e2"
    sha256                               ventura:        "e69b0b8c108d165d8090cb37b7c02b17f44dabc256832dbc19e0982b82e6fc4f"
    sha256                               monterey:       "74fd7a95a4a1e4d0ffddd447cb50b57a4ef5c79f1c9c3d6b8a33186c1553d0ac"
    sha256                               big_sur:        "c7cf1b87879aa86ebf4d968a052d75cf098e75886ca5356fb2c472b07bb3fc40"
    sha256                               x86_64_linux:   "227d8085455a4cfd366cab80b133fd5e80d1e2688ca6b1ed134a4df6a2cfeda7"
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