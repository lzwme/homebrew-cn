class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "827417bcf88309df170962e7bd1b4b4a4992d5d4e5cb82a0442ada9530e916d2"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "154795aac3d56668f3f09f66ca1fec0aa4f5d2b2eb015c1073420b5acfeb7cec"
    sha256 cellar: :any, arm64_tahoe:       "f75a6b56634cfb69ebf86d002d2e988db785962b936ac0a26af3e7c3b6c741cb"
    sha256 cellar: :any, arm64_sequoia:     "f4eddae4ec3df0bbb85a95d8d3ec6ff4db25042fd5ef8c6cd0bbb95a7280699a"
    sha256 cellar: :any, arm64_linux:       "85f3b4bd95d120f79430251641396c3717a62bfe9935fad515117e9d1be6a70e"
    sha256 cellar: :any, x86_64_linux:      "d4421f26e0afcd64e911355b50760e297201da89fddddef51aff4c1dadb90147"
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