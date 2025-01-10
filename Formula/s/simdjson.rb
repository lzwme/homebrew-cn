class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https:simdjson.org"
  url "https:github.comsimdjsonsimdjsonarchiverefstagsv3.11.5.tar.gz"
  sha256 "509bf4880978666f5a6db1eb3d747681e0cc6e0b5bddd94ab0f14a4199d93e18"
  license "Apache-2.0"
  head "https:github.comsimdjsonsimdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3cd894d05c2aa3a88a36936b739bb0f576cb360b33b9d50f8f9fc65acdb7abb3"
    sha256 cellar: :any,                 arm64_sonoma:  "36735b159ae146e6bf58af2d92c30ab95b559604ba4618d2c78b7a1748051aca"
    sha256 cellar: :any,                 arm64_ventura: "d740e38abc84517c2f659da9d0a30c693be578ac667e746c64dc8f4a8f20effb"
    sha256 cellar: :any,                 sonoma:        "abedc7d76dc0f203f44decccb4ea7c33670dba7f068568465175799374d78138"
    sha256 cellar: :any,                 ventura:       "ffd17fa7401b2f61c0ed423d24a11ac149932c20c3172761ce833083e26b527e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67e94a69dae410a578e9065b326afaea8addf2944962de6458277b6919a4673f"
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