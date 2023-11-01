class Zug < Formula
  desc "C++ library providing transducers"
  homepage "https://sinusoid.es/zug/"
  url "https://ghproxy.com/https://github.com/arximboldi/zug/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "1b9c8f962e40baa6f0c6af35f957444850063d550078a3ebd0227727b8ef193c"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96fbf6458c5eebb9e65299d68f5fa0eac49de340e8eeeb2bd73da0f57d06e6b4"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -Dzug_BUILD_EXAMPLES=OFF
      -Dzug_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args.reject { |s| s["-DBUILD_TESTING=OFF"] }
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <zug/transducer/filter.hpp>
      #include <zug/transducer/map.hpp>
      int main()
      {
      auto xf = zug::filter([](int x) { return x > 0; })
          | zug::map([](int x) { return std::to_string(x); });
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end