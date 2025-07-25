class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://ghfast.top/https://github.com/catchorg/Catch2/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "8061daf97429621bc62096841af02fc40070fad26cd04c93ee0b5a825cedb122"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "086528ba5159f48c78e5c683ee6e06b90bfac078565110b4dd73ffe20d2c54a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "463d7f4e9191275c7d8c68163bd3010308475ac067442da900bc59f6acc01bd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6bf6f5b017001a8b51b2f65f29454a0181aa72573577dc5040f32f9864868f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d4eb98d5337fcb4527592a234aeb5e3815de650d106614228b987404a56b390"
    sha256 cellar: :any_skip_relocation, ventura:       "6e44dbe251fb23c468b634cb96d4adbec981f4294ba9189105e9db0cfa55417c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe74061a43d78420da128ae764a9d34eec85a2054b936dd944abcd9a346e63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7361cb16c223d54371c63a814d4912676e2beebe241bf15581edcf28d9c6f3a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <catch2/catch_all.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lCatch2Main", "-lCatch2", "-o", "test"
    system "./test"
  end
end