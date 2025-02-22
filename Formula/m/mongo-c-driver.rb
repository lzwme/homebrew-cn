class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags1.30.1.tar.gz"
  sha256 "2542af022415864c08b6232da70a5323ad967e5cee183c2245e35d93eb6410a7"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "242fa98c77307cba06592181828c1c0a7f0fab4a7b2739f5ec237b82706e3bba"
    sha256 cellar: :any,                 arm64_sonoma:  "575dc9067d3d107b543d6da0baa09fa0992925e152ed8ae37e175cc1798f810c"
    sha256 cellar: :any,                 arm64_ventura: "20064d87c245b85963c249c68afa7fce952c636d637ed8bfa1e234366750c376"
    sha256 cellar: :any,                 sonoma:        "502bafc7b32c2394597ad78886b86370b41100b1adef3bc07fcad26912b3e252"
    sha256 cellar: :any,                 ventura:       "2731ee4b3a60eb3dae5aa9edcd55a19d6c646a2113a7ac810e132abd74bc932b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7ce2f4a6e8d553d8fe1bbe105d3717da8c786fcc5f704743cb0e0624387603f"
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
      "-I#{include}libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output(".test test.json")

    system ENV.cc, "-o", "test", pkgshare"libmongocexamplesmongoc-ping.c",
      "-I#{include}libmongoc-1.0", "-I#{include}libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output(".test mongodb:0.0.0.0 2>&1", 3)
  end
end