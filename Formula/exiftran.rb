class Exiftran < Formula
  desc "Transform digital camera jpegs and their EXIF data"
  homepage "https://www.kraxel.org/blog/linux/fbida/"
  url "https://www.kraxel.org/releases/fbida/fbida-2.14.tar.gz"
  sha256 "95b7c01556cb6ef9819f358b314ddfeb8a4cbe862b521a3ed62f03d163154438"
  license "GPL-2.0"
  revision 2

  livecheck do
    url "https://www.kraxel.org/releases/fbida/"
    regex(/href=.*?fbida[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "df30994dfbdb81576a7772461b04794ffbd8a909c22c448e30a3771df5e5e322"
    sha256 cellar: :any, arm64_monterey: "71b5694eacdc87a7fa6e80fcd694ae97c7ee79307aacf1dd2c5f88b4489bbcee"
    sha256 cellar: :any, arm64_big_sur:  "b58b8d6344072d85b1fe971beda49909924527a032df80494243bc1b469ecb74"
    sha256 cellar: :any, ventura:        "af9811b1544ff47d4511e4051a0b80a35b13ec6a716102c57a8884b64230414c"
    sha256 cellar: :any, monterey:       "408ca4d14477d0f8fb212091c8c69e5a8b0e37e03a0ee247439e29a85025521c"
    sha256 cellar: :any, big_sur:        "335aa0d2a4b309ce62834ee41ba1b093e405d280a6e05d1d14e12343b50d558b"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "pixman"

  on_linux do
    depends_on "cairo"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "ghostscript"
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "libxpm"
    depends_on "mesa"
    depends_on "openmotif"
    depends_on "poppler"
    depends_on "webp"
  end

  # Fix build on Darwin
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/185c281/exiftran/fix-build.diff"
    sha256 "017268a3195fb52df08ed75827fa40e8179aff0d9e54c926b0ace5f8e60702bf"
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "RESDIR=#{share}", "install"
  end

  test do
    system "#{bin}/exiftran", "-9", "-o", "out.jpg", test_fixtures("test.jpg")
  end
end