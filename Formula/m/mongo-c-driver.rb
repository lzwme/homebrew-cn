class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags1.29.1.tar.gz"
  sha256 "bc7d861192948ea9f5898867b7c9a8ce57b6b775d8d45591d2cc3db7eb637671"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25ba735ffb61294af4806ea19208dcc27ea9eee2ec45c647f3478f6d650af1fc"
    sha256 cellar: :any,                 arm64_sonoma:  "6d1443980ddbf551113c34307560d06c1a0ef05679e19948ced3e3b4d1152221"
    sha256 cellar: :any,                 arm64_ventura: "45ba5549157d95d90e7a3f5fea023f8f67db10356a2065d39d7fd80c44b686da"
    sha256 cellar: :any,                 sonoma:        "bfd445a4cd04afc10c706e32785dd49c63cc1e2979baef7ce81cbef780ceb753"
    sha256 cellar: :any,                 ventura:       "8cac51cd969cbc9f070c57f85dcc1f178a1f86a70ad54e6e51f3d40a4bc44375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a10b81629a9b481681abeb5ae061aea6d03276a199910000576f4495d030f5d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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