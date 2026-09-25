class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghfast.top/https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.12.tar.gz"
  sha256 "adae21ca3457b1b280b2e844d6aa85d6a781e645b8f85e8e05f1b2c23d6c0280"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "00db73014800900ef1bc74fe2345b1a0ebbef0eafea01d7a4c75e7080719e1a0"
    sha256 cellar: :any, arm64_tahoe:       "929519b78ad2678ffca2545b02b69819232ac8417938361ee2837080a21afd92"
    sha256 cellar: :any, arm64_sequoia:     "5f17e61bbf0176af4a77deabf494d4ff76865aa0ec0b53d120c8ec6de5876412"
    sha256 cellar: :any, arm64_linux:       "8946831a59747da8502b9d7a98145b1bcac284fcd9df558f3f279076d0366838"
    sha256 cellar: :any, x86_64_linux:      "b9b9ad38f78e7ef22aaa53e647166e0b6aa9249a2edce9593dc85b36eb227bc4"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained
  disable! date: "2027-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "zstd"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

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