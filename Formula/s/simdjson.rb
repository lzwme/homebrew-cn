class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghproxy.com/https://github.com/simdjson/simdjson/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "5802702e72d0b615627af33b15dc50bcb55e6acb17193c95078581dd806e50e4"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d3c225fa8323fd51e6ff7739b8bb479407ba12657c5d245d96bfd524ad60921"
    sha256 cellar: :any,                 arm64_ventura:  "d009750bb5b81227a19211b741d9f1279d70beb3af477ab3fff07af8d80c1b2a"
    sha256 cellar: :any,                 arm64_monterey: "b6942ed3395c6763a487957a0330423c3221ab075191f1f7d0d7bb7e12107f46"
    sha256 cellar: :any,                 sonoma:         "66204805a4e928cd4b96e56470f9a0d45097a7d5e35dfacb3280bfa04451b78e"
    sha256 cellar: :any,                 ventura:        "bacf1b80e76e74884b5a0bbd22c79495bc4fe6cb041c60f8239f1e92750a58b8"
    sha256 cellar: :any,                 monterey:       "284d6b9b32736f1856c21ecc2047cc5f04d5424eacd9f52473396bf7748a8863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec322897aed5476c845c7eaef39945883f40dadd250e48efc044532e84794c84"
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