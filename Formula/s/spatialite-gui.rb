class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https:www.gaia-gis.itfossilspatialite_guiindex"
  url "https:www.gaia-gis.itgaia-sinsspatialite-gui-sourcesspatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 8

  livecheck do
    url "https:www.gaia-gis.itgaia-sinsspatialite-gui-sources"
    regex(href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4eee338a4607cd90e789a315c02265a2c8bd2ccc55ee700262f3f8b54365ec10"
    sha256 cellar: :any,                 arm64_sonoma:  "ccb385ee1b9552f92b27ebd63d10629c7ebe9acf9061a81e5a3a8c14dcf8f40a"
    sha256 cellar: :any,                 arm64_ventura: "795211d944e14bcc3b04ea8d6c450acf5c3d5d50ca48db10172feb8974f4a058"
    sha256 cellar: :any,                 sonoma:        "335538f5d90c2d2920cb673059d613c0dcc1bb27d4ae301666324c809d4412ca"
    sha256 cellar: :any,                 ventura:       "3ce2ac8828663ee702b980b5cde60e9b2ae2fdc7d6ae9ed2c98fe70b724bae3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "450ade9edc957ad4a4ca18b3927730934d9a97c05910aedbf890e76d0a83e54b"
  end

  depends_on "pkgconf" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libpq"
  depends_on "librasterlite2"
  depends_on "librttopo"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxlsxwriter"
  depends_on "libxml2"
  depends_on "lz4"
  depends_on "minizip"
  depends_on "openjpeg"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "virtualpg"
  depends_on "webp"
  depends_on "wxwidgets"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https:github.comHomebrewhomebrewissues44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    system ".configure", "--prefix=#{prefix}",
                          "--with-wxconfig=#{Formula["wxwidgets"].opt_bin}wx-config"
    system "make", "install"
  end
end