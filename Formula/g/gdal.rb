class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https:gdal.orgenstable"
  url "https:github.comOSGeogdalreleasesdownloadv3.11.0gdal-3.11.0.tar.gz"
  sha256 "723d7b04e0f094be2636128d15165b45059ac5e53f143cbbd93280af0b347abd"
  license "MIT"
  revision 2

  livecheck do
    url "https:download.osgeo.orggdalCURRENT"
    regex(href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "727b00881d381e31da5c7e89ffef714c527206554b8771ccd15c6a7493ea1653"
    sha256 arm64_sonoma:  "04ee8d3927ad992fb5ae9b98213a1ba775e21eefa5b6527846a5d4570ecdc27e"
    sha256 arm64_ventura: "1e6bfc2dc9116e55d1aa87a7666ebbda0efac2b10a9c7fe980db8599203c15f2"
    sha256 sonoma:        "c225b49ef288fbc2a12f5d558ec3fcc657482935481050a26352b166511b9fd4"
    sha256 ventura:       "12f01ab7cc8688afea61446c3b536c7cbda0e3d09679817b54e830975ca7bce9"
    sha256 arm64_linux:   "662111cad7babb2f3a8c40aa2866855e3183ce0304b699c96572c578a5f48fc0"
    sha256 x86_64_linux:  "1c4f127414443cb0dd6d7c363a0e646c047ffa0df803fcade16b7b572621c442"
  end

  head do
    url "https:github.comOSGeogdal.git", branch: "master"
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