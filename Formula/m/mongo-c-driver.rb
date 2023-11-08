class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghproxy.com/https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.25.1.tar.gz"
  sha256 "28eb6658aabf4f3f065f2e9b0edc62446cf3b80b3e676a17d72be0b4ccc5372c"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5257ebb93e353c5ee1ddb4a01d5e38b6a3420c5f2a1038d5804825dacbcf3c9d"
    sha256 cellar: :any,                 arm64_ventura:  "bfa1d10f82bc65e89f94d3ced4be5002cd8bbe14b9734c0cb8d5e62ff3fed41e"
    sha256 cellar: :any,                 arm64_monterey: "077f57bf0d98fb6b6f63681a80a8e3bbc5045b92c62cdae839620d8ba44b2843"
    sha256 cellar: :any,                 sonoma:         "7ebbf70c8c02340488149f8210bb216f10b65d2ca6866a7119d942c93a615d97"
    sha256 cellar: :any,                 ventura:        "c2ca9548a95b3505ed1cde69a5afa99e61cfd2d2a0557c012372dfcb603dc3bf"
    sha256 cellar: :any,                 monterey:       "878f5472760a6969c8cbc510706bb85bae51e9a469e39a942e765e6f108b36d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e416ca43892cb85df7939b565091521d1c0dad7b98abbb9c81954d189197eccd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    File.write "VERSION_CURRENT", version.to_s unless build.head?
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