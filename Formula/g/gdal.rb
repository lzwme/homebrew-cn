class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https:gdal.orgenstable"
  url "https:github.comOSGeogdalreleasesdownloadv3.10.2gdal-3.10.2.tar.gz"
  sha256 "ca710aab81eb4d638f5dbd4f03d4d4b902aeb6ee73a3d4a8c5e966b6b648b0da"
  license "MIT"
  revision 4

  livecheck do
    url "https:download.osgeo.orggdalCURRENT"
    regex(href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "194b322c0b83fafc143851792b0d4077f4d7fdcad2d2f646e3b5f3dec6113fdd"
    sha256 arm64_sonoma:  "ed663739bc8022bd26da630ccfcbadab0fcfca3737fb697fa653b0234b0260ee"
    sha256 arm64_ventura: "a4e57f33b534e90a7bc010e5e2207733e654c7fdf0463a9d5b916f9fe7b5eb45"
    sha256 sonoma:        "ebd71cf736190a2b455e5ca5ba254d16b9316b947c9dcb4d758c6b111c5ce30c"
    sha256 ventura:       "79185271488cecb60ef303a19a7af37498e6138a1ca0e4b0cfed72a7a8e451a6"
    sha256 x86_64_linux:  "7ae5121d4ef6abbbd811eb81da3aa9cf8ce1d3bcd2336b507686c2c6b0a92559"
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