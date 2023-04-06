class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.1.6.tar.gz"
  sha256 "232d9c99689720f4a7006740d3b239d63d2e853abefe3a8b6bfbcedd2879cf91"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70d59894620591b0bcaa33952d4404d091815d17d4cf7265ed4b1d1016462071"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81439ecc206d84c4e4622e2424e945cfff41120e269beb35e2c1c0e642759fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9fc401b96e3a9404aa32b4e32849a585a933da7de2389ea2337e0aa2e6f6357"
    sha256                               ventura:        "8b6969dad7c53b7520838e56eeab510321cf32d42984a3703624dd8621b7ff98"
    sha256                               monterey:       "265f7b6bba32b5be5634d4fea5454ff558d98edc94ea9db04ef95ee7832a7f12"
    sha256                               big_sur:        "b9aff762ca2e188f990778fccdb2d598f0e966d67ef23c6210d1e99c09ba776b"
    sha256                               x86_64_linux:   "6fe9c9fcff026ebd5b270bc0e0132f2456eb1b58f7c1950960ef7440721027f4"
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