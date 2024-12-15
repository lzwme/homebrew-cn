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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1f613ed783723d1c8f22fc5799de2a8843149a9929c86e24447db112b51c7af9"
    sha256 cellar: :any,                 arm64_sonoma:  "758ea92c37b344836203f1ac8dc133728b28401c78d2a011fa6c6f0a3e1878f2"
    sha256 cellar: :any,                 arm64_ventura: "5f402a33207b4159b9cadd041e76b684db858b1311c026b472f92010d0a8f7ab"
    sha256 cellar: :any,                 sonoma:        "e360e2a6bd07c1fca1dd05a2330ad1ef3bc3f94dc7d12ebc9bae542446892a32"
    sha256 cellar: :any,                 ventura:       "d2e55453d4ff5bd72654744edcab792fa86f58a5d3fd2d29b7b55204b9d598ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d6461639c2ebb72b258bf1e535919513985f83fbceaaa7725be0f4768b635d"
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
  depends_on "python@3.13"

  uses_from_macos "curl"

  def python3
    "python3.13"
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