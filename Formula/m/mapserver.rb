class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https:mapserver.org"
  url "https:download.osgeo.orgmapservermapserver-8.2.0.tar.gz"
  sha256 "26ec2d951ca502483586bf7849dc99b8b378cd4764e47bf0555a3f12fa3d9053"
  license "MIT"

  livecheck do
    url "https:mapserver.orgdownload.html"
    regex(href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e18afbe412d4dcf4e8fc559e52efcaa248fe90342a12b78e636175959f18ef0"
    sha256 cellar: :any,                 arm64_ventura:  "a882c78762debea42f7a044508bb41bd8db14562c056480422dcd816c1c7464b"
    sha256 cellar: :any,                 arm64_monterey: "390500cf99ba5aac784e122e7f00440067c1380ca0b9c9c1bf399ed7da7861aa"
    sha256 cellar: :any,                 sonoma:         "fcd5d5af6d55b983a913bcf285a776929d613cdbaff0b22e63d91e554e7f8dd2"
    sha256 cellar: :any,                 ventura:        "606e7e774c64bc76e8457bf2871aaa42826070dee36e45ef5fc4c7fb9639c07d"
    sha256 cellar: :any,                 monterey:       "e1292b5e53a659b2e8a23aecf1167e7306a1de0951bdfbf69dfe553ba5ce19f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a357774a6fbdf4a4095d2913a6d4d282d0a1c53853687077b93b7c058ce079"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

    # Workaround for: Built-in generator --c_out specifies a maximum edition
    # PROTO3 which is not the protoc maximum 2023.
    # Remove when fixed in `protobuf-c`:
    # https:github.comprotobuf-cprotobuf-cpull711
    inreplace "CMakeLists.txt",
              "COMMAND ${PROTOBUFC_COMPILER}",
              "COMMAND #{Formula["protobuf"].opt_bin"protoc"}"

    if OS.mac?
      mapscript_rpath = rpath(source: prefixLanguage::Python.site_packages(python3)"mapscript")
      # Install within our sandbox and add missing RPATH due to _mapscript.so not using CMake install()
      inreplace "srcmapscriptpythonCMakeLists.txt", "${Python_LIBRARIES}",
                                                       "-Wl,-undefined,dynamic_lookup,-rpath,#{mapscript_rpath}"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
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
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPHP_EXTENSION_DIR=#{lib}phpextensions"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), ".buildsrcmapscriptpython"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mapserv -v")
    system python3, "-c", "import mapscript"
  end
end