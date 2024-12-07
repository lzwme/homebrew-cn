class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https:simdjson.org"
  url "https:github.comsimdjsonsimdjsonarchiverefstagsv3.11.0.tar.gz"
  sha256 "f3469e776ca704cfda47f0a43331690c882f82c9c0c6f185452387c1e222a63e"
  license "Apache-2.0"
  head "https:github.comsimdjsonsimdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aef76ff6b949fb69a5fecd77fd258623ee6203c646b1b592560c5ac592327bd2"
    sha256 cellar: :any,                 arm64_sonoma:  "e2e4d1d4c3bf34f91531a3c8a446313b8a0a6648144f1c6e42c38d333f41ac6a"
    sha256 cellar: :any,                 arm64_ventura: "3648ee1e141fcfff0ebb29f74584c256016ee70d0ace25dd81e67a13b4e33456"
    sha256 cellar: :any,                 sonoma:        "07eae2cfcdd88261ea5bbe98d115308c21080caa9ca8ac7f9459bcd5b67db8c6"
    sha256 cellar: :any,                 ventura:       "e7f73e678a7f823d57a9c2157d11e0aea1b53d56ff279aa57272ba0f59a9c4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "678fe55bb1c3e90f6c7aed29e031a855a68c377931bb0906a3d332843e8bc824"
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