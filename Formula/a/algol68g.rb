class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.6.tar.gz"
  sha256 "3c1362c71b185fd384ff2cf7dbd4173957370e6496214a944cd51a167b844700"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2aec2d53c6a6dadffec1da72abb5e974d420533899aa7c86a9a0af21bf2d343d"
    sha256 arm64_sonoma:  "5fece065567f1acf173cb4eeaec3ea889f70bb9b23ce336f64da9c779f1a05b3"
    sha256 arm64_ventura: "85b2e37d20e97ecb7da1fdcaccbb078dfac0d6baf82e6ed3cfdf566dde9f2cd7"
    sha256 sonoma:        "b59d62a3324eddf39256b66e1725e7d9f2e01fd828dc5ce57bfefcc15537c930"
    sha256 ventura:       "68662af964ad01cfeea2defdbb6e2bd0214365fc8f6bad2c6d74baad671d9989"
    sha256 x86_64_linux:  "12496c9edc38bb01ae1cffc800c10e9e8123b517211286f0ef16f59886f64693"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
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