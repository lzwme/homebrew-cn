class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://ghfast.top/https://github.com/mongodb/mongo-c-driver/archive/refs/tags/2.2.2.tar.gz"
  sha256 "ac04c7125f2eae0288f11ddeb1aa76fd318df7228ff3484aa9b415aed52665e2"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e030a8e11fb749b2c139f7ab17eae42b0b25e18320e714101a9ab4668e97dd42"
    sha256 cellar: :any,                 arm64_sequoia: "88866bd39983a3cc2df75048e2330ece3732b81e4e73bd6a8cf0c4cca6f046bb"
    sha256 cellar: :any,                 arm64_sonoma:  "9ea42156445e23e3057478ba46561a2b102f9a6de1348fcebf2667a426c5698a"
    sha256 cellar: :any,                 sonoma:        "035335e1b308d1033a82d9bc7ce6df7ba81a98b1e3fffb187c290f60d17e0dad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33cbe95ae81336300d8cc2bafe4009bfd40efe3ac4be2001b0d747584b22cbf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b976dc8eb00e21d415bb453dd01775567feefdf0886affb7ebe673068fcdd6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "zlib"

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