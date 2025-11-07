class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.4.1.tar.gz"
  sha256 "fe60bfdbab69437b5f97bb4ca41f2407e245c90edc2a727bf1d4428edb4a240f"
  license "MIT"
  revision 1

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a43649b2a040b852c66909714c3e98f53b222e7a39d4d0c7a550127b84e8c27a"
    sha256 cellar: :any,                 arm64_sequoia: "1831094bcdeed7ae471f63a3666d79bf83c7b75cc2f623984010b3ab6d9da992"
    sha256 cellar: :any,                 arm64_sonoma:  "6c504fe2b7be80638e01bb9c5aeca76686ecf3fa79e9b8d75af911be8d76d9f3"
    sha256 cellar: :any,                 sonoma:        "16b865a0960aa049991f5e97454806197b438ebf92910b2fdcf1489df2b65da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2581a19731ae34f501c8c77765b010c25f662057d85d80a003e4b54943e7f9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e591a076f5a12dfc9130a8d409992e1cf9b8d21d48696503d46e5a997aa3e22"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "fcgi"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "geos"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "pcre2"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.14"

  uses_from_macos "curl"

  def python3
    "python3.14"
  end

  def install
    if OS.mac?
      mapscript_rpath = rpath(source: prefix/Language::Python.site_packages(python3)/"mapscript")
      # Install within our sandbox and add missing RPATH due to _mapscript.so not using CMake install()
      inreplace "src/mapscript/python/CMakeLists.txt", "${Python_LIBRARIES}",
                                                       "-Wl,-undefined,dynamic_lookup,-rpath,#{mapscript_rpath}"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DWITH_CLIENT_WFS=ON",
                    "-DWITH_CLIENT_WMS=ON",
                    "-DWITH_CURL=ON",
                    "-DWITH_FCGI=ON",
                    "-DWITH_FRIBIDI=OFF",
                    "-DWITH_GDAL=ON",
                    "-DWITH_GEOS=ON",
                    "-DWITH_HARFBUZZ=OFF",
                    "-DWITH_KML=ON",
                    "-DWITH_OGR=ON",
                    "-DWITH_POSTGIS=ON",
                    "-DWITH_PYTHON=ON",
                    "-DWITH_SOS=ON",
                    "-DWITH_WFS=ON",
                    "-DPython_EXECUTABLE=#{which(python3)}",
                    "-DPHP_EXTENSION_DIR=#{lib}/php/extensions",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./build/src/mapscript/python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end