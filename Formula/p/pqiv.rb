class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https:github.comphillipberndtpqiv"
  url "https:github.comphillipberndtpqivarchiverefstags2.13.2.tar.gz"
  sha256 "154cbbe0a62be12cee23b0a46a86b2305d8128fd19924308ad5e9d22fa5ad4f7"
  license "GPL-3.0-or-later"
  head "https:github.comphillipberndtpqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b042df8a068c4fde409474ed443668e1dd0577d3f5c08e7ff802db858e437f60"
    sha256 cellar: :any,                 arm64_sonoma:  "2bf2a9f1526dc9896f93b19f2fdbb0e8c5454e7c568cb8cd4544d01ce97decec"
    sha256 cellar: :any,                 arm64_ventura: "299ac27a10711f9356c3441cfd017d347ef186d26b003dfaba20d46aa7b03ffc"
    sha256 cellar: :any,                 sonoma:        "d2ea4af0a5f3ede0a684deb4fbb2e68e2a25c532d1a3a746ffe2444e1981757e"
    sha256 cellar: :any,                 ventura:       "74ebcf13821a3001bf8f50de8ed6da662696660066e426ffa79f7fd380954600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca7b62e81548299e7eabc1bda872d2c2bd7849a1029b74bd5b3476e97fbb9f17"
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