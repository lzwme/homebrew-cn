class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jun2023-SP3/MonetDB-11.47.17.tar.xz"
  sha256 "fa7f2fcf3153e3cb3ae5c964a732d0216d62f9b3d3448f06a6fd29fe0604cad9"
  license "MPL-2.0"
  head "https://dev.monetdb.org/hg/MonetDB", using: :hg

  livecheck do
    url "https://www.monetdb.org/downloads/sources/archive/"
    regex(/href=.*?MonetDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "742b18ac8b12a2af43e80ece1e93b7e98867ac451007701edd65b8859f9e1751"
    sha256 arm64_ventura:  "9da841adc79f8723c9a7739034c1869ee4573722259ac4f2d87b3ae2c9674662"
    sha256 arm64_monterey: "0dc04e6ec4ec6a8149c5d1ab70b32a867bd9c9da7a1cc9d0cae9d644a676fde1"
    sha256 sonoma:         "cd23acb1dca2ecf73870b5b5dab9199a8abee27a3ab32c2002552a7ccb50d462"
    sha256 ventura:        "3b1dc6fba5430675beeb70ceacc7b77a5d8c96da9c013b83b20175ddf09a290e"
    sha256 monterey:       "37128b55078ccd18f6d058dc91ae14d9f0fa736a55cb501705aacb85294835e8"
    sha256 x86_64_linux:   "af46e457115a2af149ea1ea5b934f962cdb72c38d9b1855dd09de7b8b193b473"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit
  depends_on "xz"

  uses_from_macos "python" => :build

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