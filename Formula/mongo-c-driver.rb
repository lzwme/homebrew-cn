class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghproxy.com/https://github.com/mongodb/mongo-c-driver/releases/download/1.24.0/mongo-c-driver-1.24.0.tar.gz"
  sha256 "c37d8965f1e22236241e9474190110cfeeededbe9aa7c630ce8a9c379e97fc47"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a75b4b6176db4acd9706c8c6044e4b9332e8ad5356969da3f3e62073297358c0"
    sha256 cellar: :any,                 arm64_monterey: "3322e25740024b28c81fe1f641ddcc510b86152df118b6ba5f40ae2299c3d324"
    sha256 cellar: :any,                 arm64_big_sur:  "ce3ace4a5cc9f15dd8547cd11eaa9a234464d41a942f638793f7c202fc8d485d"
    sha256 cellar: :any,                 ventura:        "266802cbecacbe0af6ada7edf2de581880ae03b667eccaa7ef3676849cd30c54"
    sha256 cellar: :any,                 monterey:       "2dc39b332fd4165b4e65c3ccaf4bf05396173e6f54ce5349c08dec183a065afc"
    sha256 cellar: :any,                 big_sur:        "1ba00bbda82284e4301f5c4d436dc93a38c7c2feb74f22566d25101cee8e9d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f13b5aca6ebde2e8f77252ffacae186b2275e9fc1f9f86d50a99f11ac4df9093"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    inreplace "src/libmongoc/src/mongoc/mongoc-config.h.in", "@MONGOC_CC@", ENV.cc
    system "cmake", ".", *cmake_args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end