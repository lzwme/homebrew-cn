class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghfast.top/https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.5.3.tar.gz"
  sha256 "96c28a43e30942abe39d687143b974fee2b947a177a4080f3a6f70af795e5869"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8aabc8095b11e21a39c694cef2acc4ac4915917e4f167aba149bb6f7f56f7630"
    sha256 cellar: :any, arm64_tahoe:       "ee43285e61d0b5692fae8bcbae9b1c87eda3718fb3041b5ca97f607e137d6664"
    sha256 cellar: :any, arm64_sequoia:     "a08cb70dafbc0ecec27861209280ceec748c8529739ad5c63f7955af954eb368"
    sha256 cellar: :any, arm64_sonoma:      "ddd1651a813079bc84700848b00e4045dc68a01150073e3153e459e76d94146d"
    sha256 cellar: :any, arm64_linux:       "75cff9cc199f7e8c401a7c0a7ec97d1fa42ac04c31a4c696ab8a427994fcc0fe"
    sha256 cellar: :any, x86_64_linux:      "54607816884effdf829f2a9ffb51b7a070f0f2ff95261fcd4126325cdcb64f4a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    File.write "VERSION_CURRENT", version.to_s if build.stable?
    inreplace "src/libmongoc/src/mongoc/mongoc-config.h.in", "@MONGOC_CC@", ENV.cc

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/bson-#{version.major_minor_patch}", "-L#{lib}", "-lbson2"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/mongoc-#{version.major_minor_patch}", "-I#{include}/bson-#{version.major_minor_patch}",
      "-L#{lib}", "-lmongoc2", "-lbson2"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end