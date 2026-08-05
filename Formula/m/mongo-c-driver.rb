class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghfast.top/https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.4.0.tar.gz"
  sha256 "e924836aaf4cd8c9b26b587b993aeef5b4976c71fd9c8b8a7165dc76ff36e00c"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de62c3536e6fce1925cbf05be31bcb386ac85077f3260c09c86648870f21ca73"
    sha256 cellar: :any, arm64_sequoia: "a2fc9ef3acdf1d4318b5d7deaf75a5d1f13636b18385c4407bb186c9841b0aed"
    sha256 cellar: :any, arm64_sonoma:  "621ae07fbc528c19a13603468c28188e19bf8344dad1dcb5527b377dfc7ab4db"
    sha256 cellar: :any, sonoma:        "da665db020b7ee5b25d1bbf184ae9934274e8fcdf6de3b63e7ec7605236bc648"
    sha256 cellar: :any, arm64_linux:   "5ec6454ca9b0ae4f802d9351b7841bd07f938934e39cb08081450a1440ba8bf1"
    sha256 cellar: :any, x86_64_linux:  "62644e02292073e63f2e4d97417fac7eaa61696899946168cffd6833435d79e2"
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