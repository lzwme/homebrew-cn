class Dispenso < Formula
  desc "High-performance C++ library for parallel programming"
  homepage "https://github.com/facebookincubator/dispenso"
  url "https://ghfast.top/https://github.com/facebookincubator/dispenso/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "fefabf77cfda64e42190335693c0a8b4b2201bf07f360b37a098a0396c7737a9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8012ee3c6ba9d59a3fba1c5ff75be213aaa2d4f1522d4917cb577c6f68ea391d"
    sha256 cellar: :any, arm64_sequoia: "328df74a05790e2ab360857534577379e003169235e3bda7eccb8d89bad041ba"
    sha256 cellar: :any, arm64_sonoma:  "ea7aa45139f52b60d3eb93eebfe387dd07247db051ce0adac75588d41be09b86"
    sha256 cellar: :any, sonoma:        "5ec73f838050bde9546949da2c76d7b001f8fb37b96790f9d2e3256e787f209e"
    sha256 cellar: :any, arm64_linux:   "189cf224f1c8838ac9e92817a26db18ca3aba2625afae42ff22559e8237d0243"
    sha256 cellar: :any, x86_64_linux:  "93d5d92f727af9015c8053c26514fabbbaf745209eb75d93739f9b837de41f50"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DDISPENSO_BUILD_TESTS=OFF",
                    "-DDISPENSO_BUILD_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dispenso/parallel_for.h>
      #include <atomic>
      #include <cstdlib>

      int main() {
          std::atomic<int> sum(0);
          dispenso::parallel_for(0, 100, [&sum](int i) {
              sum += i + 1;
          });
          return sum.load() == 5050 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(test_dispenso CXX)
      find_package(Dispenso REQUIRED)
      add_executable(test_dispenso test.cpp)
      target_link_libraries(test_dispenso Dispenso::dispenso)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test_dispenso"
  end
end