class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https:simdjson.org"
  url "https:github.comsimdjsonsimdjsonarchiverefstagsv3.11.3.tar.gz"
  sha256 "eeb10661047e476aa3b535d14a32af95690691778d7afe0630a344654ff9759a"
  license "Apache-2.0"
  head "https:github.comsimdjsonsimdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b1670e9480231a9b45811c533a98dfde28e4fe6c5ff347d8ff1e673f6af23314"
    sha256 cellar: :any,                 arm64_sonoma:  "97de9abc29eb3e42ab57c579185aefd928a0d843fb02a323baecfc1edf82fd8d"
    sha256 cellar: :any,                 arm64_ventura: "d5024fa12ba5a4e4e78b4b5d524c2ffd856cae45c00cb45f3575f60342c8fa3c"
    sha256 cellar: :any,                 sonoma:        "34f56718ca65959ffa5cfffe8f833c151ffa0d3ab31c21f1368735352d09f720"
    sha256 cellar: :any,                 ventura:       "b3c1a8f21d3b3e5447ce5c62228076c0cfba247188944a4416456068ff1141f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e05315bca5c4f7ad0c0b652a42627067cbef49f678407ae9ebcf3913764f02d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "buildlibsimdjson.a"
  end

  test do
    (testpath"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath"test.cpp").write <<~CPP
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
    assert_equal "\"Homebrew\"\n", shell_output(".test")
  end
end