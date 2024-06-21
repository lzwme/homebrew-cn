class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.13.tar.gz"
  sha256 "bb8f312c51d202572243f113c6b62d8210301ab30cbaee604f9837d878cdf755"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "e011f7851397a725c19c5774f33fd92a880476a8ae37c5c9f23a5d4aad084cac"
    sha256 arm64_ventura:  "10788f93e331dd93dab2eb899fa31593b72fedcb789a0c7c807c4647c495d7f9"
    sha256 arm64_monterey: "5eab278d0efbc37c53c5780bd0b7a709698d7339637268b13f0e943c06ef843b"
    sha256 sonoma:         "c7c06e9774f028033a5204a67a76024ffc8b0f9abdba542ca314f2af92c0d524"
    sha256 ventura:        "e4c884c473f6ac563510f45077f13108f48ada926b9c973e4207612f5cd77695"
    sha256 monterey:       "18605b71d83d1d0cf0162b79d24e74917572cfb132aca81e11ed20570f8b3c7d"
    sha256 x86_64_linux:   "f3cbd363b695aecf683d92a8b56aa5cb9a8d7e3d81b6190892c8393de7f4d648"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"

  uses_from_macos "zlib"

  conflicts_with "csound", because: "both install `extract` binaries"

  def install
    ENV.deparallelize

    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "Keywords for file", shell_output("#{bin}/extract #{fixture}")
  end
end