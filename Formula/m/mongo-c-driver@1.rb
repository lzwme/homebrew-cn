class MongoCDriverAT1 < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghfast.top/https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.30.10.tar.gz"
  sha256 "b66fe996492170059dd547f2a3469b819d86b13e819220a84d999bc20b84ed26"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5a794a8ce7c266113c8477c8850b0b42b7ee799a93e19dc1fc973542f8440b3"
    sha256 cellar: :any, arm64_sequoia: "f4e3b5cda11badf430552291c68197ca3acca2f76e2a7280940a23a5c7d915ec"
    sha256 cellar: :any, arm64_sonoma:  "a21bd442e2eb20adcec258d89733740f010477f09ebd773919974f7bf55e3ec9"
    sha256 cellar: :any, arm64_linux:   "5c7384aabfafd990393e342c9702222e7b03fd63608ea9bd7dcbc50dec5e8367"
    sha256 cellar: :any, x86_64_linux:  "026d5643669185407581ca3f266f898f48d0f2243ad964f1d50c0c6c8452abf6"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-04-01", because: :unmaintained
  disable! date: "2027-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
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