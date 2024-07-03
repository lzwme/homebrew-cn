class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags1.27.4.tar.gz"
  sha256 "37898440ebfd6fedfdb9cbbff7b0c5813f7e157b584a881538f124d086f880df"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a207b82e6d737b2c559d59ee7249202bdce7ace1f42684d18ac0fa85fc9a629e"
    sha256 cellar: :any,                 arm64_ventura:  "063b046c5259ef39f169c731fc9552d4af33721dd1a876b4857e633d59f9a04b"
    sha256 cellar: :any,                 arm64_monterey: "bdfad6d998e4ab48c13ff709957afdd7c7f31b0e9aaac13abaec97a2f3cd4f33"
    sha256 cellar: :any,                 sonoma:         "b0c4f064c566a2bd4e68c7916171fb1c36c63de063e8f14823822d5fa6643458"
    sha256 cellar: :any,                 ventura:        "defe679f3f59ea34757118cb5d12cc09f9c0405ee7ab89bcccb368b7c788402d"
    sha256 cellar: :any,                 monterey:       "90e2eaac48d15833580d0d9e70a043c305f80973d3fd0bbfe84d34c405bf3f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59390b3133855e6705d03746ea8f61dad735297e88d27e6b38566b9cd39f92ff"
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