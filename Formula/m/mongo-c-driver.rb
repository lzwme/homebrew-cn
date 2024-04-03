class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https:github.commongodbmongo-c-driver"
  url "https:github.commongodbmongo-c-driverarchiverefstags1.26.2.tar.gz"
  sha256 "7084c488a758bf226cc0b3d500e7e001f0e2e37391cbeecd341050a9a899857d"
  license "Apache-2.0"
  head "https:github.commongodbmongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "475d204e3da9e98d1c2635180b4393355604f010423e4cf8ade92d1e6547d959"
    sha256 cellar: :any,                 arm64_ventura:  "7511a752c295cfa4c3c4a07e65bd5f9cf0dda5ddea88990b8f4f79aeb30b87f4"
    sha256 cellar: :any,                 arm64_monterey: "a9104efe896a88a6989335e743535bc8efa2bda0fa60149b8098005a39b5d7a7"
    sha256 cellar: :any,                 sonoma:         "ab56278c3a9dc74f30daedc4fe7e2a191e9434222e45b1ee1076df94a8818bd8"
    sha256 cellar: :any,                 ventura:        "178dff2db20ba0d90db3cfc3530423df2bbaa0ac6293b28799d734a06aee2a53"
    sha256 cellar: :any,                 monterey:       "d2a5cac0d1510b68f64b68730f5985e042cf1e442acfb1dc44433606e17b6c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5ba5346e949e2143efb5c8878b1515337fe603deb6d1d9709c211c6b13cc3f"
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