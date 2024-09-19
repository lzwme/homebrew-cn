class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags1.28.0.tar.gz"
  sha256 "fc8ef2d081d9388b9016d74826f4a229d213a2813708d26063d771ab12e457cb"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8ae916ca0fe5aaf2435aeb02211bf2ef323834bc6088a2f4305003599e6fb7c"
    sha256 cellar: :any,                 arm64_sonoma:  "07561192178d208bf885f4908e38b659f8f6dc986f6f457e806f584770315730"
    sha256 cellar: :any,                 arm64_ventura: "e256ac69d7c678ded1b83e598001d316a5c5c9c337067a8bd8124190e48cd52d"
    sha256 cellar: :any,                 sonoma:        "326553b8d8f1e7f9675e7de957d8e9fb007cd0a67185e6df19863b92d4917fd1"
    sha256 cellar: :any,                 ventura:       "0fd8b193bf01ef41437f973e08208af3137df1600cffb63a00112b6a0cff93d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b5706220ddd48ae36ecb24dfb23438ab49b8f1035722881b96625f30a34e5c7"
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