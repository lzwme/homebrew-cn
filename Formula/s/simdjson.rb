class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghproxy.com/https://github.com/simdjson/simdjson/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "76601d1701232a212b62d25d3a6518219b2504ff84e8073c6df7393b2ead3176"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01b44838d46880646a1c4f3eb6d1120c6e0eba0061f37918be5cc41dc5f49b8f"
    sha256 cellar: :any,                 arm64_ventura:  "a9d8969a847b44b0627b14dabb4c05e11f17a44bab5c1abfc922cf1d522b688a"
    sha256 cellar: :any,                 arm64_monterey: "8deb9f5ebf49cdb8502bb981839a8fc9f0296ad0927767157952ef9eb920487f"
    sha256 cellar: :any,                 sonoma:         "d38d47e6ca4df941dd2c396bd8019e8e115255904df238cb92561cdc12efa346"
    sha256 cellar: :any,                 ventura:        "99a8aa5f70fdaed85e221d61f2891f8a4e8a9c3cfe9836a87e01464d149135c1"
    sha256 cellar: :any,                 monterey:       "e872164e873b459a680921090c6010061b661226d8638f31bf6d031e0abe672b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b98d1572cba32b1ad94f9a2e59f6ac0051352b342e9a84ea82ee2a0126501b"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end