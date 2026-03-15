class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://ghfast.top/https://github.com/simdjson/simdjson/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "d493cf4e5c60afab90cb4a3d58620c5a17904676076e927f715815d903ef4d08"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "883818a18c6d50ef903bc4104430ef24c1896b56a7f39b28539d3d01ed5b806a"
    sha256 cellar: :any,                 arm64_sequoia: "5a4034e6f15e89d9825632af4c1f47ac344c54a13c662619c33f3a4d59a65946"
    sha256 cellar: :any,                 arm64_sonoma:  "dd6527ba6132b6f36a95fa13742fb746f1ddd1f254657e274807db2dba858c43"
    sha256 cellar: :any,                 sonoma:        "1aa88f3e8e89a13511ced0fa116a4095553040504638f3381c6fa1fab407be1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57899516b8bfc12420bc416d66aabf4e5c1061357a412d52d4f3f89ff0a357ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "838480de0388cd9e9b876855a248b018d57bd752e42ecd8786a79beebca4624d"
  end

  depends_on "cmake" => :build

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