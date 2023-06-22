class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghproxy.com/https://github.com/mongodb/mongo-c-driver/releases/download/1.24.1/mongo-c-driver-1.24.1.tar.gz"
  sha256 "f9bdf71f24c6621c12535bad07f4654a218d84f16b85a68aca3abf6cd36d1859"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a257a894a75aca6242277f599457eb639023fc41305c52b989f244c79a3a43ae"
    sha256 cellar: :any,                 arm64_monterey: "5cbbeb1f4d2be2810cf20250914fafdf2dd8322db33ad12fbdc6dd902cf2e2ab"
    sha256 cellar: :any,                 arm64_big_sur:  "14b9cb083d0e68be897de2f4149b026f3de8a198fc01e324d75a318b3a1e58ee"
    sha256 cellar: :any,                 ventura:        "ea25a551b22b38923e3457ecef6c981a5ccf888a6fa67f654a2eed01a9978c9f"
    sha256 cellar: :any,                 monterey:       "f40ea6c34b7835397f7f3c35f3fc740148e793768aa9f09da8bd5ad5c173cd9e"
    sha256 cellar: :any,                 big_sur:        "1c1152b90d5cd89136409263ebbea2abe30b6670b03dc26d65df283858148f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43482eea859016c9d460bc6b85aa33dba7682a3ecffbbd7d7803e8c8bb4aac46"
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