class MagicEnum < Formula
  desc "Static reflection for enums (to string, from string, iteration) for modern C++"
  homepage "https://github.com/Neargye/magic_enum"
  url "https://ghproxy.com/https://github.com/Neargye/magic_enum/archive/v0.9.0.tar.gz"
  sha256 "2fb2f602b4660f8af539ee00958132a397e138bda19aa1ceae546de3a143386b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b6e2f521f83215c48ad1e3e9d03f2617b1dce096f2e87a47f5d900d01096188"
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