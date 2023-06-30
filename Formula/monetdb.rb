class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jun2023/MonetDB-11.47.3.tar.bz2"
  sha256 "d2f85c3e1e195c200aa6089266cb6eeaf050bfb57039873aaa8cfc74f92e80d1"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "42e634e0c26a575303b6ceeff4d48458efd43b86e63ad7a95e344b4aded5cc9b"
    sha256 arm64_monterey: "9c3b932e548d32e4adbedc640768d183b620e9458575e864e84a686764dabdfc"
    sha256 arm64_big_sur:  "aa3a66d0f03a32832189ae91130fb5a390d04e3c69eafb60d436e988fb0df0cb"
    sha256 ventura:        "81bd8fc885c3a7fb5edddfed417ed1c1a1df8f9d205734f37086701ffaa4bd8e"
    sha256 monterey:       "e005ee15396797c832a00368a1280c09ea6bad6854d27e88be7670b36de30eb5"
    sha256 big_sur:        "07787a63a775a6451217d5f7e15866130f5c0cc5942bea35fb1dfe27d9457082"
    sha256 x86_64_linux:   "c021889f3a249c10e92620403f11601c68cdbe2dbc033df73ed69fd94947bf3e"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "lz4"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DRELEASE_VERSION=ON",
                      "-DASSERT=OFF",
                      "-DSTRICT=OFF",
                      "-DTESTING=OFF",
                      "-DFITS=OFF",
                      "-DGEOM=OFF",
                      "-DNETCDF=OFF",
                      "-DODBC=OFF",
                      "-DPY3INTEGRATION=OFF",
                      "-DRINTEGRATION=OFF",
                      "-DSHP=OFF",
                      "-DWITH_BZ2=ON",
                      "-DWITH_CMOCKA=OFF",
                      "-DWITH_CURL=ON",
                      "-DWITH_LZ4=ON",
                      "-DWITH_LZMA=ON",
                      "-DWITH_PCRE=ON",
                      "-DWITH_PROJ=OFF",
                      "-DWITH_SNAPPY=OFF",
                      "-DWITH_XML2=ON",
                      "-DWITH_ZLIB=ON"
      # remove reference to shims directory from compilation/linking info
      inreplace "tools/mserver/monet_version.c", %r{"/[^ ]*/}, "\""
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    # assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
    system("#{bin}/monetdbd", "create", "#{testpath}/dbfarm")
    assert_predicate testpath/"dbfarm", :exist?
  end
end