class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghproxy.com/https://github.com/mongodb/mongo-c-driver/archive/refs/tags/1.25.2.tar.gz"
  sha256 "b6cefc2f5296596d1b1358779c009bdffaae3c4ab77b935de3306ddc2309d389"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8ed61ca723af7bcb67e6b9d2c8545f0f992c46988f8b4b683bde755c2f106d0"
    sha256 cellar: :any,                 arm64_ventura:  "32e60a295abc1e053a4ee674ba9e3e5e5cde689cff1a276678400acbb28cba96"
    sha256 cellar: :any,                 arm64_monterey: "485ac738334ffb966016b575a61b6dda24f6c28f726b433bc08a888557ae8ec6"
    sha256 cellar: :any,                 sonoma:         "0dcc29fbebcddcb943e994847d052fabe9af72e5cffce219052efb897baed590"
    sha256 cellar: :any,                 ventura:        "e1cc4f488a323b8b0aac9efa8a602d250c455015c55b4e3d6fcfe60b26a2f872"
    sha256 cellar: :any,                 monterey:       "4f8eb97f2daaf01b3fbb29e00dbc32b05c9896f7ed2a6ab0cb143bba83dabaf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3361115ce3468f6a006b0cf589f6c347916c8cd2c4d04bc8cc2461b7f2136c47"
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