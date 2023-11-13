class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://ghproxy.com/https://github.com/Neargye/magic_enum/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "0ffc840d881a377a520e999b79ec2823b3b8ffadccad5d94084cc37fcf6fe2c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65ef8321b4638f71dd6366ac3568583fc984f4aa22356ba3a0ea594c6a66140e"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5" # C++17

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "./test/test-cpp17"
    system "./test/test-cpp17"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <magic_enum.hpp>

      enum class Color : int { RED = -10, BLUE = 0, GREEN = 10 };

      int main() {
        Color c1 = Color::RED;
        auto c1_name = magic_enum::enum_name(c1);
        std::cout << c1_name << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-std=c++17", "-o", "test"
    assert_equal "RED\n", shell_output(testpath/"test")
  end
end