class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "295e96d96d6d55face58e99b47ddc1f6c7c1a302f2ce5edf2c1ba7518972f0ed"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b70992199d7ae5a050f9b892c6ba79522c032e21733e408743538a351f816b25"
    sha256 cellar: :any, arm64_tahoe:       "2090cde68e91c5fc5726c5e313fb6480e61acebd3ed0ab56b749d496fa80b765"
    sha256 cellar: :any, arm64_sequoia:     "096785d15117c33cafa6076af92e359385d2e22ff3a94fd5e6c6de4ff1343168"
    sha256 cellar: :any, arm64_linux:       "38d5679b0afd29fe94bf7561b1a035e637b790f7ab38a215209fc2ea61336f43"
    sha256 cellar: :any, x86_64_linux:      "7486cd5238d5e1de866eb047eb8f09574960015fdb1bea4a148546de27552722"
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