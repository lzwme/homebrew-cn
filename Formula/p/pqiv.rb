class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https:github.comphillipberndtpqiv"
  url "https:github.comphillipberndtpqivarchiverefstags2.13.2.tar.gz"
  sha256 "154cbbe0a62be12cee23b0a46a86b2305d8128fd19924308ad5e9d22fa5ad4f7"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comphillipberndtpqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3d54712bd03655312a997147a91890cc477219132460f8a2ad6d58fc36a4a02"
    sha256 cellar: :any,                 arm64_sonoma:  "11f241ac7b2b77c45c2ee3ef2aa1326249c1252ab09ac28f2599b9d8b1ba1e9d"
    sha256 cellar: :any,                 arm64_ventura: "1db22601e9f0b7657b36391c575aa714187987cab63a1e97138969dd4e67e250"
    sha256 cellar: :any,                 sonoma:        "438374c3d22978722298b967661fe29cf95b0f696f35502e0753a5e4b81f3047"
    sha256 cellar: :any,                 ventura:       "a72256f4130713429c9f5ce6182007f492d71129980b66baedc25723233c8417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e310939daa1cc85a570febbeeac273d1edc8131b136b35f765ce536eea3f977"
  end

  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libtiff"
    depends_on "libx11"
  end

  def install
    args = *std_configure_args.reject { |s| s["--disable-debug"]|| s["--disable-dependency-tracking"] }
    system ".configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pqiv --version 2>&1")
  end
end