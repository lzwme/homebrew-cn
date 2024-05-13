class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https:mapserver.org"
  url "https:download.osgeo.orgmapservermapserver-8.0.1.tar.gz"
  sha256 "79d23595ef95d61d3d728ae5e60850a3dbfbf58a46953b4fdc8e6e0ffe5748ba"
  license "MIT"
  revision 5

  livecheck do
    url "https:mapserver.orgdownload.html"
    regex(href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d5ed41478fb9897954f63c4d3339010b2288244e43d63b79909c423c5d85bc2"
    sha256 cellar: :any,                 arm64_ventura:  "54cb5a214989e7eb42c0f686386d1d771ca622464bae6d1bb55fa329d85ec943"
    sha256 cellar: :any,                 arm64_monterey: "7fc4536901adfa19051a317da922ced9cc2289cde8e747979274c2a1c907b894"
    sha256 cellar: :any,                 sonoma:         "64f311b6e3531d97e52fca71fcbd3f793f6dba4656a32aa8b83c382423c195a5"
    sha256 cellar: :any,                 ventura:        "00a9ff0fd5bc7ca68c89547266286e836bc6e64e48bbcee9340742e4fdbdad9b"
    sha256 cellar: :any,                 monterey:       "7acaef1305698b865be99be12fdfaab7dae98a764efb34f5a70644806ad7d5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f849b429a007f142f65d64511f95fba0db1603069be93546f6a7299e9c5916d7"
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
  depends_on "libpng"
  depends_on "libpq"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.12"

  uses_from_macos "curl"

  fails_with gcc: "5"

  # Backport fix for libxml2 2.12.
  # Ref: https:github.comMapServerMapServercommit2cea5a12a35b396800296cb1c3ea08eb00b29760
  patch :DATA

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
      inreplace "mapscriptpythonCMakeLists.txt", "${Python_LIBRARIES}",
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

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), ".buildmapscriptpython"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mapserv -v")
    system python3, "-c", "import mapscript"
  end
end

__END__
diff --git amapows.c bmapows.c
index f141a7b..5a94ecb 100644
--- amapows.c
+++ bmapows.c
@@ -168,7 +168,7 @@ static int msOWSPreParseRequest(cgiRequestObj *request,
 #endif
     if (ows_request->document == NULL
         || (root = xmlDocGetRootElement(ows_request->document)) == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_OWSERR, "XML parsing error: %s",
                  "msOWSPreParseRequest()", error->message);
       return MS_FAILURE;
diff --git amapwcs.cpp bmapwcs.cpp
index 70e63b8..19afa79 100644
--- amapwcs.cpp
+++ bmapwcs.cpp
@@ -362,7 +362,7 @@ static int msWCSParseRequest(cgiRequestObj *request, wcsParamsObj *params, mapOb
     * parse to DOM-Structure and get root element *
     if((doc = xmlParseMemory(request->postrequest, strlen(request->postrequest)))
         == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_WCSERR, "XML parsing error: %s",
                  "msWCSParseRequest()", error->message);
       return MS_FAILURE;
diff --git amapwcs20.cpp bmapwcs20.cpp
index b35e803..2431bdc 100644
--- amapwcs20.cpp
+++ bmapwcs20.cpp
@@ -1446,7 +1446,7 @@ int msWCSParseRequest20(mapObj *map,

     * parse to DOM-Structure and get root element *
     if(doc == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_WCSERR, "XML parsing error: %s",
                  "msWCSParseRequest20()", error->message);
       return MS_FAILURE;