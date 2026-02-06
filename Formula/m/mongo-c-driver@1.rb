class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghfast.top/https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.7.tar.gz"
  sha256 "addac1f20d280a1a55fdbcb73edf929af74b9768b61c92d77703466f51d6885a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b9da71919127335440ca2fc3f0f09ee41706ba30bea1609192b81b5951a18f9"
    sha256 cellar: :any,                 arm64_sequoia: "afd3399fc01330370155d4861b3bbebece5fcdcf864b1b8c12ee0ae5164959ac"
    sha256 cellar: :any,                 arm64_sonoma:  "49caadc951f3368d3120371435ed1e4adad2465ca12a7d7e2820f96a85974ed8"
    sha256 cellar: :any,                 sonoma:        "a7e62636ebe340df30bf11bbe56423b9d37f35f33313385fc44824da09bc4e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47cf380da20c771e66c363d318e350d4103c3a249c3a50408d3a1eba94738061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74f2a73f7048a2e4a64c81b915bd15c8c8bb905887dffc57d32c258277cada1"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    File.write "VERSION_CURRENT", version.to_s
    inreplace "src/libmongoc/src/mongoc/mongoc-config.h.in", "@MONGOC_CC@", ENV.cc

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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