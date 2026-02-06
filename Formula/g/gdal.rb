class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://gdal.org/en/stable/"
  url "https://ghfast.top/https://github.com/OSGeo/gdal/releases/download/v3.12.1/gdal-3.12.1.tar.gz"
  sha256 "266cbadf8534d1de831db8834374afd95603e0a6af4f53d0547ae0d46bd3d2d1"
  license "MIT"
  revision 4

  livecheck do
    url "https://download.osgeo.org/gdal/CURRENT/"
    regex(/href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "275592823d824cb6756fbbd032a56cea73fcd75a4caf89d048fb348e496f8a87"
    sha256 arm64_sequoia: "17a731ef6f6aff6090a91b6a3fa64705c2f62bde5f4be7d88be666f4e89a1f8e"
    sha256 arm64_sonoma:  "ff90ab40bd81253262ac942dc0a5eb773630082aa75a349e12c53cbc7127abc6"
    sha256 sonoma:        "001e8fc69875d2c4b0dd8bdd2b54a94b39d659f104996d38a8b4d656728d1db6"
    sha256 arm64_linux:   "5139df28e8f50d6bd2d2ad523b0450b22ddca6324a903b32f84e2bf46b75a4fc"
    sha256 x86_64_linux:  "c96f16f427006aedc329393a979a3b1970fe1c1444cca16bf366ae92d247c1f3"
  end

  head do
    url "https://github.com/OSGeo/gdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "apache-arrow"
  depends_on "c-blosc"
  depends_on "cfitsio"
  depends_on "epsilon"
  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "hdf5"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-c"
  depends_on "libaec"
  depends_on "libarchive"
  depends_on "libdeflate"
  depends_on "libgeotiff"
  depends_on "libheif"
  depends_on "libkml"
  depends_on "liblerc"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "lz4"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "poppler"
  depends_on "proj"
  depends_on "python@3.14"
  depends_on "qhull"
  depends_on "sfcgal"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "minizip"
    depends_on "uriparser"
  end

  on_linux do
    depends_on "util-linux"
  end

  conflicts_with "avce00", because: "both install a cpl_conv.h header"
  conflicts_with "cpl", because: "both install cpl_error.h"

  # Backport fix for poppler 26+ compatibility, remove in next release
  # PR ref: https://github.com/OSGeo/gdal/pull/13664
  patch do
    url "https://github.com/OSGeo/gdal/commit/28a15cb76d26a27be96ab8b8bc8fcb52c153c3a9.patch?full_index=1"
    sha256 "89171ad0d0e9edd531022011c59d1d0ae21910b4c69c44ab453c5722c82fe297"
  end

  # fix for poppler 26.02+ compatibility, upstream pr ref, https://github.com/OSGeo/gdal/pull/13850
  patch do
    url "https://github.com/OSGeo/gdal/commit/8f2e654223e9fbde0978eea0d8f03ad6f091ad8c.patch?full_index=1"
    sha256 "51d3016957ef82cae333780c82523979aae7c338d9c38fd9b6d18f971e171335"
  end
  patch do
    url "https://github.com/OSGeo/gdal/commit/c8ff7e31650cb61acf40903928aabf2514754038.patch?full_index=1"
    sha256 "8f57f13342b1d7e7fcfc5920a9e4943478661f126d45a5646b99cdae8ceff264"
  end

  def python3
    "python3.14"
  end

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    remove_brew_expat if OS.mac? && MacOS.version < :sequoia

    site_packages = prefix/Language::Python.site_packages(python3)
    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "swig/python/CMakeLists.txt",
              'set(INSTALL_ARGS "--single-version-externally-managed --record=record.txt',
              "\\0 --install-lib=#{site_packages} --install-scripts=#{bin}"

    osgeo_ext = site_packages/"osgeo"
    rpaths = [rpath, rpath(source: osgeo_ext)]
    ENV.append "LDFLAGS", "-Wl,#{rpaths.map { |rp| "-rpath,#{rp}" }.join(",")}"
    # keep C++ standard in sync with `abseil.rb`
    args = %W[
      -DENABLE_PAM=ON
      -DBUILD_PYTHON_BINDINGS=ON
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DPython_EXECUTABLE=#{which(python3)}
      -DGDAL_PYTHON_INSTALL_LIB=#{site_packages}
      -DCMAKE_CXX_STANDARD=17
    ]

    # JavaVM.framework in SDK causing Java bindings to be built
    args << "-DBUILD_JAVA_BINDINGS=OFF" if OS.mac? && MacOS.version <= :catalina

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install (share/"bash-completion/completions").children
  end

  test do
    # basic tests to see if third-party dylibs are loading OK
    system bin/"gdalinfo", "--formats"
    system bin/"ogrinfo", "--formats"
    # Changed Python package name from "gdal" to "osgeo.gdal" in 3.2.0.
    system python3, "-c", "import osgeo.gdal"
    # test for zarr blosc compressor
    assert_match "BLOSC_COMPRESSORS", shell_output("#{bin}/gdalinfo --format Zarr")
  end
end