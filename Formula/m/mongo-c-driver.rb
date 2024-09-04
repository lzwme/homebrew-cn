class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags1.27.6.tar.gz"
  sha256 "7dee166dd106e3074582dd107f62815aa29311520149cda52efb69590b2cae7a"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "522cde02943eca570125f5716c0a267e62daf432ae977f293f2036164cd72f89"
    sha256 cellar: :any,                 arm64_ventura:  "2124d7d0afb43b2389ca8320187ff464eadf2f182eae601a09e7d3808c0b3745"
    sha256 cellar: :any,                 arm64_monterey: "80a12501de4632de28ba1de24bf2b9de05c7c171f3f7b096f1ffa781c072e19b"
    sha256 cellar: :any,                 sonoma:         "145ab282f1219735c085ad6ac7fd53b7c8dab9b588cc128d15bbeb02e35a6f35"
    sha256 cellar: :any,                 ventura:        "226981164116348c88e796ca945d6db9452dca11b8dc762f74307325b70c26f7"
    sha256 cellar: :any,                 monterey:       "61a2723beb212326aaa3c0268a0329c4c5975d7ceba5278e6bb9fc4cc5b886fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64715f041085c5b53e3172b7ea823b76cfd7847157e07e93e4cca95b1532c54d"
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