class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghproxy.com/https://github.com/mongodb/mongo-c-driver/releases/download/1.24.2/mongo-c-driver-1.24.2.tar.gz"
  sha256 "25813a220188d40140ca9c36a4b23abfb68fc7cbb37694187cc9852be470abd2"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "52e15a30e729c225d7e27ee8bafbac7ddba7eddea17f812d24a7a8f687cb3daa"
    sha256 cellar: :any,                 arm64_monterey: "b3dd87633ec65a03bfbf80e4efa25aaaab8ed3161d24691d718af877edaafa5d"
    sha256 cellar: :any,                 arm64_big_sur:  "2d1e21a260e168b89127dd18ac9109a96b20f2affc74a925d61404627bb6b5d0"
    sha256 cellar: :any,                 ventura:        "caddc68c03176bc14d100344e1b47fc2c52a5060a774044d567f36ff7163d780"
    sha256 cellar: :any,                 monterey:       "d9b18e00b79f9a12fe57bd0939f9197e1b47c30083a8f07cb3bbbfe4ab25e66f"
    sha256 cellar: :any,                 big_sur:        "d9d42f3b665ed5eb63b180772878405eafa944173790d263f48a9157b044206a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afca70119a4355116a2979290b92fd0bbb750880e28b0c5259eb14a9a0a52409"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

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