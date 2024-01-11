class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https:www.gdal.org"
  url "https:github.comOSGeogdalreleasesdownloadv3.8.3gdal-3.8.3.tar.gz"
  sha256 "f7a30387a8239e9da26200f787a02136df2ee6473e86b36d05ad682761a049ea"
  license "MIT"

  livecheck do
    url "https:download.osgeo.orggdalCURRENT"
    regex(href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "326e28420f603c4cb45c9426330829cb9a3bfd554abe6a07bad4851bf79fb683"
    sha256 arm64_ventura:  "6845105b6a84ef035035593ef557ddaf7928128e654fb0043a83bc8909f59ed8"
    sha256 arm64_monterey: "d8c88fcd57d6bf6edeea32a1b305212544fc6ddefb5fa44ee5f3d55d214fb4c9"
    sha256 sonoma:         "aff263b6363db76c76206e401d1e98cb8aab0fcd8a183d5ee8496b7c4c74f45d"
    sha256 ventura:        "9dc5347129169f74270b044ca35c62aac5978ad8229a23e4d17245e809954666"
    sha256 monterey:       "0e575ccb614d07fe2a28298ceff3e4f5c3f5eb6a2659445bc4646a5f40ef1f86"
    sha256 x86_64_linux:   "dd938028348abd2a783c441213a48c35a204258cf1fcc64f4ce5f5af46a24867"
  end

  head do
    url "https:github.comOSGeogdal.git", branch: "master"
    depends_on "doxygen" => :build
  end

  depends_on "boost" => :build # for `libkml`
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "apache-arrow"
  depends_on "cfitsio"
  depends_on "epsilon"
  depends_on "expat"
  depends_on "freexl"
  depends_on "geos"
  depends_on "giflib"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-c"
  depends_on "libarchive"
  depends_on "libgeotiff"
  depends_on "libheif"
  depends_on "libkml"
  depends_on "liblerc"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "poppler"
  depends_on "proj"
  depends_on "python@3.12"
  depends_on "qhull"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "xerces-c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  conflicts_with "avce00", because: "both install a cpl_conv.h header"
  conflicts_with "cpl", because: "both install cpl_error.h"

  fails_with gcc: "5"

  def python3
    "python3.12"
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
  end
end