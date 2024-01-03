class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags1.25.4.tar.gz"
  sha256 "0ab3c5b238803b82a6b217d1ef21ea71a6e96251063322dc1038bea70a3da541"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bfc83ab7bf397c82e69171ad67c364ece7699dd334f60054af3017aa803acc43"
    sha256 cellar: :any,                 arm64_ventura:  "20572c6695d6c53ae7a774fa3bc0ca4dac713c8e3bf447a1a72e6720e8a66a77"
    sha256 cellar: :any,                 arm64_monterey: "71c4b1650d9d7ca9251e886c8cedc40973f0f9dd3f40fb712786b4ecf5923f0f"
    sha256 cellar: :any,                 sonoma:         "b484ae1b3b4da5d84ee2dc3958ff4f5cb108574fbb161836ebc595ede541cc87"
    sha256 cellar: :any,                 ventura:        "44154af8a5cb401159560f1954739b14e395b24d3aefc40b7d2d0f487e2ea8d1"
    sha256 cellar: :any,                 monterey:       "8d445014c4e4e77e7e867893e42e2374280c52f4a15d884fed1eecb697121a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ff5a8a85490bcd496963020da8e51a9fee1f6584be5ddd5c332f3b5ca0e782d"
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