class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.4.4.tar.gz"
  sha256 "ce05c4e45e2e7638fb382fa54516f114000147abee349e5b028ba076c9476cb9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "711e505ff4d5c844761180d39a91fe0e4ab7c211b13c3d6bdd2eb3168fa79e71"
    sha256 arm64_ventura:  "75b3d76261812c4286d731be4cf5774c6008339321b18465db9732115a4ee89a"
    sha256 arm64_monterey: "0bc9a106239de008014af3c60a380b3a69f7eda6cb339ce6832458911c68647c"
    sha256 sonoma:         "5364e342b12eeb3db042ff354e268e2771c76abf6716105d83dcb59d73bd9862"
    sha256 ventura:        "5db8ea42be359428dc7b2d2c42724ac4c62fbb398e25f85b9866971b6a4650a5"
    sha256 monterey:       "f7f7912bfff368b02613ae52bab32b4f4dc22b547f21c3fc673aa968733271dc"
    sha256 x86_64_linux:   "b5f95697e60db8f57bde0c909a46747f0c5781fe3f104eb820fcba0b0184a0ba"
  end

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