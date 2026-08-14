class Dispenso < Formula
  desc "High-performance C++ library for parallel programming"
  homepage "https://github.com/facebookincubator/dispenso"
  url "https://ghfast.top/https://github.com/facebookincubator/dispenso/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "1c188b8593411080d653776595a15049f9e7eecd5212b31b3ee7bb094ff63971"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e7fe740ee8314cc35382510e6a0df2e31bf611c16afd79c3dcfcec51a85d1dd"
    sha256 cellar: :any, arm64_sequoia: "37919965282de1126db7802cf41a38342e7e1a47f6f908476e9bd8ae6408a119"
    sha256 cellar: :any, arm64_sonoma:  "99faf8ff2cdac7972345ac3dda077d8667bd1b65a21b2989ea61ead70c202d27"
    sha256 cellar: :any, sonoma:        "1c0ad068d844c7177d1cd10925e525f7f54e4af3d1e5381138a74f8bb0b1600e"
    sha256 cellar: :any, arm64_linux:   "a81c359ce094e2765c917d372ef2896c03f8389355031f709b015fe3e2a31d48"
    sha256 cellar: :any, x86_64_linux:  "954fefd5a4b74170470cb17690b8103d729d6991dadee05e56cfa8c510df6a18"
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