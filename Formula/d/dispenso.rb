class Dispenso < Formula
  desc "High-performance C++ library for parallel programming"
  homepage "https://github.com/facebookincubator/dispenso"
  url "https://ghfast.top/https://github.com/facebookincubator/dispenso/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "1773991c164b723567fcdf922651f75e7d2611ab36efd87dd0cd3ef20b135e2f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aed31c67ff2da3bb908ce48d22504d629de1221a985b2f933c1dd4c5f1e723b3"
    sha256 cellar: :any,                 arm64_sequoia: "862c9592e1da9fcdc45cf7761485d1cb6bad4f5019111e06e77c7c09412f3884"
    sha256 cellar: :any,                 arm64_sonoma:  "7290d05b525575120e29bea9dadddc41a67a562759bb24294bb6a2ec63399c99"
    sha256 cellar: :any,                 sonoma:        "91843b2b96397ca0f3703e26bda81bcb6cf84043748403e1342966221526cdea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee6b672c615beaa35e8e9d5ad49edb1db790d8abd7bb1a41a5a85fc1e43dcbe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8a09e3ab0135d2945e391be34d7afe55e27527909db12dfe3226b37c2a74635"
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