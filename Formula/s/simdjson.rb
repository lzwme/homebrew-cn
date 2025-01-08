class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https:simdjson.org"
  url "https:github.comsimdjsonsimdjsonarchiverefstagsv3.11.4.tar.gz"
  sha256 "1029aff6bcca7811fb7b6d5421c5c9024b8e74e84cd268680265723f42e23cf2"
  license "Apache-2.0"
  head "https:github.comsimdjsonsimdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc319239397e71cf6aa2188a53985f2aa339f63300c35b19434ad5650643d3a4"
    sha256 cellar: :any,                 arm64_sonoma:  "ce94892fed204ac7b14a8ec5f39a11b8f4b7b2833b93cb858c6c9b7ad1a73bfc"
    sha256 cellar: :any,                 arm64_ventura: "d94d1744121cd05b80be2d1833523198faa7dc10d665dcad2e9b8e49d09568a0"
    sha256 cellar: :any,                 sonoma:        "6ecaaec172bd63797e638bdfff11f2168817860e5a9335ada6a21229028f1fc6"
    sha256 cellar: :any,                 ventura:       "349d3f9accc2bf5242444cde0856ef825bb60dcf9ff1ba306d6d9e030d4fffef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f44c622ea399dd01706e667825545df2da40b87d5696cf7f4dadb065525aa26"
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