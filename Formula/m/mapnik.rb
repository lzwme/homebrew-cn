class Mapnik < Formula
  desc "Toolkit for developing mapping applications"
  homepage "https:mapnik.org"
  license "LGPL-2.1-or-later"
  revision 24
  head "https:github.commapnikmapnik.git", branch: "master"

  # TODO: Try switching to CMake build on next release as it works better with
  # Homebrew's build environment and avoids `--env=std` when using `scons`.
  stable do
    url "https:github.commapnikmapnikreleasesdownloadv3.1.0mapnik-v3.1.0.tar.bz2"
    sha256 "43d76182d2a975212b4ad11524c74e577576c11039fdab5286b828397d8e6261"

    # Fix build with Scons 4 using Arch Linux patch. Remove in the next release.
    # Ref: https:github.commapnikmapnikcommit84a05a6597a941acfad220dae3fbfe5d20bfeb26
    patch do
      url "https:raw.githubusercontent.comarchlinuxsvntogit-community239768d7cd1217d5910d3f7d8ace86a7f85ad23ctrunkscons4.patch"
      sha256 "79a85ddba3ec17b86cb216e21442611498a9f2612f03e98708057b3c3a6e8b06"
    end

    # Fix build with Boost v1.83 using Arch Linux patch. Remove in the next release.
    # Ref: https:github.commapnikmapnikpull4413
    patch do
      url "https:github.commapnikmapnikcommit26eb76cc07210d564d80d98948770c94d27c5243.patch?full_index=1"
      sha256 "085408d6a38c77df7f333047bb1568bf0dfdf9c3b87fd9001997ba9b22be6d4c"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94dd63ba7ecb5f8de055efbd613844144f065e78b5e046f51ac577c479e5b002"
    sha256 cellar: :any,                 arm64_ventura:  "300673f8d8d37870cf147573bcf0ec3f7157c614048c2fd4d1a5942d74406f5d"
    sha256 cellar: :any,                 arm64_monterey: "d1e92ee5bff69dd5d1ca137b607cc9daaff9e0c33021058238f1d2e4c63b7124"
    sha256 cellar: :any,                 sonoma:         "4c82c25fc71b27e48699d6b230148e66f3f72de34e1bf575fb0dd473c73cf906"
    sha256 cellar: :any,                 ventura:        "7021f4d49e9157221658c8092a2a3e44278389eedfbcc4ad450f48115fbfc891"
    sha256 cellar: :any,                 monterey:       "90b9b9f04966f7f502dc1668d1fab5b5733fe818957512e37e1a4ffdb385cab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fdf0bd6724468028b557eba7fbbd636abac791ee9cc137f5dc46d2d9d4be69a"
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

    # upstream issue, see https:github.comboostorgphoenixissues115
    # workaround to avoid the inclusion of `boostphoenixstltuple.hpp`
    ENV.append "CXXFLAGS", "-DBOOST_PHOENIX_STL_TUPLE_H_"

    if OS.linux?
      deps.map(&:to_formula).select(&:keg_only?).map(&:opt_lib).each do |libdir|
        ENV.append "LDFLAGS", "-Wl,-rpath,#{libdir}"
      end
      ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}lib"
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
      FREETYPE_CONFIG=#{Formula["freetype"].opt_bin}freetype-config
      GDAL_CONFIG=#{Formula["gdal"].opt_bin}gdal-config
      HB_INCLUDES=#{harfbuzz.opt_include}
      HB_LIBS=#{harfbuzz.opt_lib}
      ICU_INCLUDES=#{icu.opt_include}
      ICU_LIBS=#{icu.opt_lib}
      JPEG_INCLUDES=#{jpeg.opt_include}
      JPEG_LIBS=#{jpeg.opt_lib}
      PG_CONFIG=#{libpq.opt_bin}pg_config
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
    output = shell_output("#{bin}mapnik-config --prefix").chomp
    assert_equal prefix.to_s, output
  end
end