class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https://mapnik.org/"
  license "LGPL-2.1-or-later"
  revision 20
  head "https://github.com/mapnik/mapnik.git", branch: "master"

  # TODO: Try switching to CMake build on next release as it works better with
  # Homebrew's build environment and avoids `--env=std` when using `scons`.
  stable do
    url "https://ghproxy.com/https://github.com/mapnik/mapnik/releases/download/v3.1.0/mapnik-v3.1.0.tar.bz2"
    sha256 "43d76182d2a975212b4ad11524c74e577576c11039fdab5286b828397d8e6261"

    # Fix build with Scons 4 using Arch Linux patch. Remove in the next release.
    # Ref: https://github.com/mapnik/mapnik/commit/84a05a6597a941acfad220dae3fbfe5d20bfeb26
    patch do
      url "https://ghproxy.com/https://raw.githubusercontent.com/archlinux/svntogit-community/239768d7cd1217d5910d3f7d8ace86a7f85ad23c/trunk/scons4.patch"
      sha256 "79a85ddba3ec17b86cb216e21442611498a9f2612f03e98708057b3c3a6e8b06"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9a257ccd034fa3ea008104d5d02c28b95c90f54beeb047d6acc0b84881e84e8a"
    sha256 cellar: :any,                 arm64_monterey: "38e5bddf16ae61f0ff525d299a12ca054565ed34e95e5a3076f8a1de7d1a346b"
    sha256 cellar: :any,                 arm64_big_sur:  "6c18db5681c42c287a910cc24b9d2382f249d07a9babcf8e58cb4f635198f4b5"
    sha256 cellar: :any,                 ventura:        "23d86823c6a0e0441687c2ca4265f43d444ad48af3b6373b59a53ddf83dee226"
    sha256 cellar: :any,                 monterey:       "b108c8adc831ae632ee536c7caf2a90f7728e450d0d9b7f5239c0e9def9ed15b"
    sha256 cellar: :any,                 big_sur:        "d8957ebdbd163ae177f94ee01d7961df912e4e61939a0283ada3b9ac92f68617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a6d02cd3cbe3b78803032d2467d681b7261eac31cd7985862eb76a21634cdf"
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtiff"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "webp"

  uses_from_macos "zlib"

  def install
    boost = Formula["boost"]
    harfbuzz = Formula["harfbuzz"]
    icu = Formula["icu4c"]
    jpeg = Formula["jpeg-turbo"]
    libpng = Formula["libpng"]
    libpq = Formula["libpq"]
    libtiff = Formula["libtiff"]
    proj = Formula["proj"]
    sqlite = Formula["sqlite"]
    webp = Formula["webp"]

    # upstream issue, see https://github.com/boostorg/phoenix/issues/115
    # workaround to avoid the inclusion of `boost/phoenix/stl/tuple.hpp`
    ENV.append "CXXFLAGS", "-DBOOST_PHOENIX_STL_TUPLE_H_"

    if OS.linux?
      deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
        ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"
      end
      ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    end

    args = %W[
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      CUSTOM_CFLAGS=#{ENV.cflags}
      CUSTOM_CXXFLAGS=#{ENV.cxxflags}
      CUSTOM_LDFLAGS=#{ENV.ldflags}
      PREFIX=#{prefix}
      FAST=True
      CPP_TESTS=False
      INPUT_PLUGINS=all
      BOOST_INCLUDES=#{boost.opt_include}
      BOOST_LIBS=#{boost.opt_lib}
      FREETYPE_CONFIG=#{Formula["freetype"].opt_bin}/freetype-config
      GDAL_CONFIG=#{Formula["gdal"].opt_bin}/gdal-config
      HB_INCLUDES=#{harfbuzz.opt_include}
      HB_LIBS=#{harfbuzz.opt_lib}
      ICU_INCLUDES=#{icu.opt_include}
      ICU_LIBS=#{icu.opt_lib}
      JPEG_INCLUDES=#{jpeg.opt_include}
      JPEG_LIBS=#{jpeg.opt_lib}
      PG_CONFIG=#{libpq.opt_bin}/pg_config
      PNG_INCLUDES=#{libpng.opt_include}
      PNG_LIBS=#{libpng.opt_lib}
      PROJ_INCLUDES=#{proj.opt_include}
      PROJ_LIBS=#{proj.opt_lib}
      SQLITE_INCLUDES=#{sqlite.opt_include}
      SQLITE_LIBS=#{sqlite.opt_lib}
      TIFF_INCLUDES=#{libtiff.opt_include}
      TIFF_LIBS=#{libtiff.opt_lib}
      WEBP_INCLUDES=#{webp.opt_include}
      WEBP_LIBS=#{webp.opt_lib}
    ]

    system "scons", "configure", *args
    system "scons", "install", "--jobs=#{ENV.make_jobs}"
  end

  test do
    output = shell_output("#{bin}/mapnik-config --prefix").chomp
    assert_equal prefix.to_s, output
  end
end