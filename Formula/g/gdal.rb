class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https:www.gdal.org"
  url "https:github.comOSGeogdalreleasesdownloadv3.9.1gdal-3.9.1.tar.gz"
  sha256 "46cd95ad0f270af0cd317ddc28fa5e0a7ad0b0fd160a7bd22909150df53e3418"
  license "MIT"

  livecheck do
    url "https:download.osgeo.orggdalCURRENT"
    regex(href=.*?gdal[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "9dd583c679b723c8584c1f19d0524b16a11f39b2e004e6d84a576e2fa5234c83"
    sha256 arm64_ventura:  "ee000d500f7369d08843d6d5d7b418582a948fb7abf5ceef0cbb0ac7258ea195"
    sha256 arm64_monterey: "873865d13b402fe9e62698f88ad4ab3d9dbce53859882c8b2d934ec870b1374d"
    sha256 sonoma:         "3df8bf489b1abfd608b622fc839c40a3026cf90846e5246758b01399911b3876"
    sha256 ventura:        "f524f71a7ef1e6c0cc36b4b573fc6696d150f253244932c52efa3ff300bb1c71"
    sha256 monterey:       "d4c529215f85fdf77006196c39ffb31e9c2f916a2b95d9062c582f2775af68c4"
    sha256 x86_64_linux:   "3d612454c87e0f88ca7d33fd80067a2a82a308899b36978a5f8305822d0e1e39"
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
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-c"
  depends_on "libaec"
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
  depends_on "lz4"
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

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

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