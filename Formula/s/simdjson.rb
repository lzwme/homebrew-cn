class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "09de4289a26d3a0453569901a3837450b5b98a5c317d635eeee8e2a82b1ebe6b"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "22bc3d0aba2db5fa993202256d1fea43ca0f451b1e1d05dadc0b13c697a28d49"
    sha256 cellar: :any, arm64_tahoe:       "0d8b3198b0e1ae67955625e4682cc17dc04325936e0f7f257a6a17718fd6ffd0"
    sha256 cellar: :any, arm64_sequoia:     "45acfe53312bd870746a8385cae195206dae4640a92802ee5ff5b6befc8db7dd"
    sha256 cellar: :any, arm64_linux:       "4e53d46e073f386fdefa16793d253804632e42e33c9777bc92e60b5bfd03f11c"
    sha256 cellar: :any, x86_64_linux:      "b2649460cc179f43131e4ee17013f3358a54d2da4313d31dae63608e1cfcb786"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSIMDJSON_BUILD_STATIC_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.json").write({ name: "Homebrew", isNull: nil }.to_json)
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end