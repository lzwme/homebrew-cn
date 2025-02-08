class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https:github.comzeuxvolk"
  url "https:github.comzeuxvolkarchiverefstagsvulkan-sdk-1.4.304.1.tar.gz"
  sha256 "01f9facf95167f76d48c752c17ac602ffbc33d2e7157774e2c32a7de614b3687"
  license "MIT"
  head "https:github.comzeuxvolk.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6389f9bcab41e5566ee16fca5d5465c1410863fec4929c3d152bd32b04d46362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e8a60d3d09eae2333f5fa75c6872e50bd76e761c005c8a9e0ea7d07f15d77e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "863d46fd9e310960f37cc5c42c7c7a4ad85e1829eac029c6870beab60d6470b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f9886c70f494eeccfac950bc333791460e4de095aa013087b6c7a3bff55264"
    sha256 cellar: :any_skip_relocation, ventura:       "8cea28e7d794025e9a8850fe0b9d74c8fc7b020a2de28df5db2e3ad172671894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "965e3cb209a17668d88cc996d47f41df131b9e79b618e14a212840913da91969"
  end

  depends_on "cmake" => :build
  depends_on "vulkan-headers" => [:build, :test]
  depends_on "vulkan-loader"

  conflicts_with "volk" => "both install volkConfig.cmake"

  def volk_static_defines
    res = ""
    on_macos do
      res = "VK_USE_PLATFORM_MACOS_MVK"
    end
    on_linux do
      res = "VK_USE_PLATFORM_XLIB_KHR"
    end
    res
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVOLK_INSTALL=ON",
           "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
           "-DVOLK_STATIC_DEFINES=#{volk_static_defines}",
           "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include "volk.h"

      int main() {
        VkResult res = volkInitialize();
        if (res == VK_SUCCESS) {
          printf("Result was VK_SUCCESS\\n");
          return 0;
        } else {
          printf("Result was VK_ERROR_INITIALIZATION_FAILED\\n");
          return 1;
        }
      }
    C
    system ENV.cc, testpath"test.c",
           "-I#{include}", "-L#{lib}",
           "-I#{Formula["vulkan-headers"].include}",
           "-lvolk", "-D#{volk_static_defines}",
           "-Wl,-rpath,#{Formula["vulkan-loader"].opt_lib}",
           "-o", testpath"test"
    system testpath"test"
  end
end