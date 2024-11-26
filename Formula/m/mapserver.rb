class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https:mapserver.org"
  url "https:download.osgeo.orgmapservermapserver-8.2.2.tar.gz"
  sha256 "47d8ee4bd12ddd2f04b24aa84c6e58f8e6990bcd5c150ba42e22f30ad30568e4"
  license "MIT"
  revision 1

  livecheck do
    url "https:mapserver.orgdownload.html"
    regex(href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c4f20f2d7e825a45c9877aba01d9f1c40c9b9703801a3a82955fee81b19f2a5"
    sha256 cellar: :any,                 arm64_sonoma:  "7a3ede1841b823c77f837b1f53b708c868adcd7dae2531cc982d58218bb4609f"
    sha256 cellar: :any,                 arm64_ventura: "3eade837930fe0024a3b667768922fcee0c17ce6c1930c1c98ad66b869d78d89"
    sha256 cellar: :any,                 sonoma:        "1b610c08a39de74db79327d03d311024642a3dbda5a5285a2d76f4e833586826"
    sha256 cellar: :any,                 ventura:       "f6a6a4ec604724b29add81780802d4b3e63018492cf2c0beb7e676a48f405c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0da998cc52dde31e1508e0423744e05a0ffbb2288db5aa96df22d75eaf6f19b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "fcgi"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gdal"
  depends_on "geos"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.12"

  uses_from_macos "curl"

  def python3
    "python3.12"
  end

  def install
    # Workaround for: Built-in generator --c_out specifies a maximum edition
    # PROTO3 which is not the protoc maximum 2023.
    # Remove when fixed in `protobuf-c`:
    # https:github.comprotobuf-cprotobuf-cpull711
    inreplace "CMakeLists.txt",
              "COMMAND ${PROTOBUFC_COMPILER}",
              "COMMAND #{Formula["protobuf"].opt_bin}protoc"

    if OS.mac?
      mapscript_rpath = rpath(source: prefixLanguage::Python.site_packages(python3)"mapscript")
      # Install within our sandbox and add missing RPATH due to _mapscript.so not using CMake install()
      inreplace "srcmapscriptpythonCMakeLists.txt", "${Python_LIBRARIES}",
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
                    "-DPHP_EXTENSION_DIR=#{lib}phpextensions",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), ".buildsrcmapscriptpython"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mapserv -v")
    system python3, "-c", "import mapscript"
  end
end