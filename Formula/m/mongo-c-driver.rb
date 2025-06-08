class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags2.0.1.tar.gz"
  sha256 "3fb98aa71e292f0aabcbcf6b9bd624affafa9375ee4ab53baeababeccc194dbd"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8bffecbb658f187a2ac9cd3ce737152bc76062d6b21332f1b7a62d3f32d8e58"
    sha256 cellar: :any,                 arm64_sonoma:  "a9b2d601078acae424010d9bbfddb2660ece1f16116e2c47ae6661ae8435e7b5"
    sha256 cellar: :any,                 arm64_ventura: "a7772b3e618cd809db685a7bd21ca1a3804d03dc844ce2a7e2d20b6ab79faaef"
    sha256 cellar: :any,                 sonoma:        "06f5ed099c2498486f7b3e1ed82cca47878bc942a2effd8d9c8c3bf8b581dc1a"
    sha256 cellar: :any,                 ventura:       "f72c8393f703727a99acf996f0da2d9cdfcd01d866b5560010799d2d10e08798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35a0f6db14c9aef2e06a65c67b723bb4445f26f6987513c8b1b7edd1a413ca4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a9347cff9130e447973bcdbf13d63f21c21ef5b27e179addf92b44107b4ffc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    File.write "VERSION_CURRENT", version.to_s unless build.head?
    inreplace "srclibmongocsrcmongocmongoc-config.h.in", "@MONGOC_CC@", ENV.cc

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare"libbson").install "srclibbsonexamples"
    (pkgshare"libmongoc").install "srclibmongocexamples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare"libbsonexamplesjson-to-bson.c",
      "-I#{include}bson-#{version.major_minor_patch}", "-L#{lib}", "-lbson2"
    (testpath"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output(".test test.json")

    system ENV.cc, "-o", "test", pkgshare"libmongocexamplesmongoc-ping.c",
      "-I#{include}mongoc-#{version.major_minor_patch}", "-I#{include}bson-#{version.major_minor_patch}",
      "-L#{lib}", "-lmongoc2", "-lbson2"
    assert_match "No suitable servers", shell_output(".test mongodb:0.0.0.0 2>&1", 3)
  end
end