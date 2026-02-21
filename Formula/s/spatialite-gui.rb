class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 14

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fc7bd66aa674d6a6be9b8e3fd3ebfb66174e26941b0c23edd79fcd89210556fb"
    sha256 cellar: :any,                 arm64_sequoia: "7118ea0e87598b25d60e396039fddfcbd76cd8333379e6e23af1474c4643139d"
    sha256 cellar: :any,                 arm64_sonoma:  "05d29c133d991792119783e90852092d4d6e60bf4c878524e5aadb46fa420bed"
    sha256 cellar: :any,                 sonoma:        "cbf91ebe3e83a75378d9f2844e64adf8730b5084d804fd12e7f7ef29b1ea281e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ffead0740acde972358bbb12362614791ec773ffd9107864407011e59c74208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6175b8a99adbeee02593f9fcdc855b2f2d15e8fb073cf05b242441ae317cc47"
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
  depends_on "wxwidgets@3.2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    args = ["--with-wxconfig=#{wx_config}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end