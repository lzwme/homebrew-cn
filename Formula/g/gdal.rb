class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https:www.gdal.org"
  url "https:github.comOSGeogdalreleasesdownloadv3.10.1gdal-3.10.1.tar.gz"
  sha256 "b1c739256d074be42d67c6c3d33eee94c90a490ebb02fcb7fc21c569a6fc78bd"
  license "MIT"
  revision 2

  livecheck do
    url "https:download.osgeo.orggdalCURRENT"
    regex(href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "94921c7f36a7763c05e71eecf4c20a81cfc45bf4bfcb93241d949bca60989b45"
    sha256 arm64_sonoma:  "1e5a5c2c0d613b2329ae3367002a5f9f1243d2fa7f3533068486f7cb1e3a7845"
    sha256 arm64_ventura: "498d7cfeb3831d085269c0c136084d1d97d9bfbb0e04cc68c23549c42695c3ba"
    sha256 sonoma:        "65acd9c14b940f08cf057716f111be5c4f710b30ded382f19cc661df18917ab0"
    sha256 ventura:       "fdad06a01155baf56759527adfb8dbefad937208c1372657e96e81e0cd806ec9"
    sha256 x86_64_linux:  "a65968e019b1f6327d70d96cb4cd5c28506ab6db1cbb9d8747438d8786eeedd3"
  end

  head do
    url "https:github.comOSGeogdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "boost" => :build # for `libkml`
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "apache-arrow"
  depends_on "c-blosc"
  depends_on "cfitsio"
  depends_on "epsilon"
  depends_on "expat"
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
  depends_on "python@3.13"
  depends_on "qhull"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
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

  def python3
    "python3.13"
  end

  # poppler 25.02.0 build patch, upstream pr ref, https:github.comOSGeogdalpull11805
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesea59760694bf0187189f7008aac7cff70260db3cgdalgdal-3.10.1-poppler-25.02.0.patch"
    sha256 "67b2d107c913d155dd8ba7ff4c534bbd6a85a48a003e01e7d59a69a066fab570"
  end

  def install
    site_packages = prefixLanguage::Python.site_packages(python3)
    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIXlib since Python 3.10.
    inreplace "swigpythonCMakeLists.txt",
              'set(INSTALL_ARGS "--single-version-externally-managed --record=record.txt',
              "\\0 --install-lib=#{site_packages} --install-scripts=#{bin}"

    osgeo_ext = site_packages"osgeo"
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

    bash_completion.install (share"bash-completioncompletions").children
  end

  test do
    # basic tests to see if third-party dylibs are loading OK
    system bin"gdalinfo", "--formats"
    system bin"ogrinfo", "--formats"
    # Changed Python package name from "gdal" to "osgeo.gdal" in 3.2.0.
    system python3, "-c", "import osgeo.gdal"
    # test for zarr blosc compressor
    assert_match "BLOSC_COMPRESSORS", shell_output("#{bin}gdalinfo --format Zarr")
  end
end