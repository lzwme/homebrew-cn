class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags1.27.3.tar.gz"
  sha256 "2593048270f8426c3dc60f0a3c22c3da92ae00a3ef284da7e662a1348ca1685c"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b9a546a945a74744b71a35e686533b6b253ac735660db7620f9104a9bbbb75ac"
    sha256 cellar: :any,                 arm64_ventura:  "406b39daf8a087c4b41314ea8da351e83c834c20b1a8427d554a2be77748b156"
    sha256 cellar: :any,                 arm64_monterey: "8f3245239022671d379707df74b576eb18dd16ba93a8d92cc43df56a6d41f886"
    sha256 cellar: :any,                 sonoma:         "8014910ba3ff97dc7fb4c07964ecba875b928c53a2dc323c41eeafb88ee61c51"
    sha256 cellar: :any,                 ventura:        "33f429d43962646487a4d4e45279a9d508620ca1bb02ee0c0ac6bf736ea8cdf2"
    sha256 cellar: :any,                 monterey:       "67fa47c0ebf83aa935e4655eeb423f2b20ea39cf363bcf2d2ff6e8e93a039d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34597afbbbcaf680bf1b2ecb82df472973668e71febcd886f9cbbc043f0f6409"
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
    inreplace "srclibmongocsrcmongocmongoc-config.h.in", "@MONGOC_CC@", ENV.cc
    system "cmake", ".", *cmake_args
    system "make", "install"
    (pkgshare"libbson").install "srclibbsonexamples"
    (pkgshare"libmongoc").install "srclibmongocexamples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare"libbsonexamplesjson-to-bson.c",
      "-I#{include}libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output(".test test.json")

    system ENV.cc, "-o", "test", pkgshare"libmongocexamplesmongoc-ping.c",
      "-I#{include}libmongoc-1.0", "-I#{include}libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output(".test mongodb:0.0.0.0 2>&1", 3)
  end
end