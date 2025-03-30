class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https:www.gaia-gis.itfossilspatialite_guiindex"
  url "https:www.gaia-gis.itgaia-sinsspatialite-gui-sourcesspatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 9

  livecheck do
    url "https:www.gaia-gis.itgaia-sinsspatialite-gui-sources"
    regex(href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0e0b9b8d64eea4b19e001a42c79c3b2eb6184aaa98a964a8bff579ca1ad9d23"
    sha256 cellar: :any,                 arm64_sonoma:  "c3304f27cb7ee706675a0c65fb9804afaafc086afc7540fac4f50529a2b00ad9"
    sha256 cellar: :any,                 arm64_ventura: "4cad2916fd5ba22bc2ff7feb13fe9aa670699c69bca88b0831eb94f734e7bc7c"
    sha256 cellar: :any,                 sonoma:        "03f56cf7b1f0c4e9ef5b1b1e52beee1178e7012f7f60bf9fd7b6e8cf20898fcf"
    sha256 cellar: :any,                 ventura:       "ff895500be11689097ab6e7c270735cc5a44c213d910fedd48a9b45a060729e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d1f0882446460cd5979f7764bd83f2113599d7f35ad4f739c5403ed68bbc96"
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