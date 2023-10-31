class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghproxy.com/https://github.com/simdjson/simdjson/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "9eab3197231382b8b99d14d8ca647d6ab6bea1b40008df086d25e6f687309bf6"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "146882a27350a95af57dd8ad843e90b736599aa2646423789557e86150f54c97"
    sha256 cellar: :any,                 arm64_ventura:  "ad197bb6e1c4f0f9b709f5dfd91b5a2f113c821cfa95c3447b8cd3f5cfd5f7e6"
    sha256 cellar: :any,                 arm64_monterey: "774c91961304d1d12e3cbdbf3f70c4cf24da97d9366e764573727836ece35f4e"
    sha256 cellar: :any,                 sonoma:         "5ac0afa30d6f1b8cb6e1d8b35407926a0fc10f25f6ab10631ef113555899d560"
    sha256 cellar: :any,                 ventura:        "26b75da466a152a315757e8002a96155be28bdeb99b54d48962acfd7b22f165b"
    sha256 cellar: :any,                 monterey:       "aa6aafcc192ed5716b2fba51a4396dd8ab94a3979af93dbabfa2f99e2d1884ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f555433b609a1b112ad9f930d38772d8012cc0a4449236889adc38d6814620d"
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