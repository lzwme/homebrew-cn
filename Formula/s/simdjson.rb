class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https:simdjson.org"
  url "https:github.comsimdjsonsimdjsonarchiverefstagsv3.12.2.tar.gz"
  sha256 "8ac7c97073d5079f54ad66d04381ec75e1169c2e20bfe9b6500bc81304da3faf"
  license "Apache-2.0"
  head "https:github.comsimdjsonsimdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efff685604252098a7d159da741c53047acd3d4b8dd3dfa9b21cce15c0b4de80"
    sha256 cellar: :any,                 arm64_sonoma:  "43e325dbaba5b941df9c64b1cf1b3cbbe630f6786b03a2a1fd7caab5b29606c5"
    sha256 cellar: :any,                 arm64_ventura: "80d082282690e41609a45e745e6fc2db73a04b4f8e846e9029949168e412e424"
    sha256 cellar: :any,                 sonoma:        "4383fa8797c933fa4a6e272c3137ca9af0fe9fac676990f372afa671bc7346dc"
    sha256 cellar: :any,                 ventura:       "e4c703992b9c70820771c5586f8052bdc8a606324278ab893ad338e548f557e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6584c821561acf58ded85f3b7e774f5baf39c7de58e9cd68081b84c658be12a"
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