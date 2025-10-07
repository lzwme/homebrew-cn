class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https://github.com/zeux/volk"
  url "https://ghfast.top/https://github.com/zeux/volk/archive/refs/tags/vulkan-sdk-1.4.328.0.tar.gz"
  sha256 "048161dd5c099cc52e7bd48b9131a05ff96e379e26236132a7db66424e98cafa"
  license "MIT"
  head "https://github.com/zeux/volk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3f6d2a4c0fb6f244e03f04f5f57141568021720e6c9ad8b1d340c1e085764c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5174abf0fee631e4cbc40c6c6347bce8ec2f1eb6fbbb632a270d8e9250039fe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "482dc043c929e5894ecba5b79680efad993a36b2ff034f010b7b1610b4c1af3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "479331d2eb51487b5e814bbf1904a9a4f3d3a520477b1b9f0bab1674c552ece4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b296af467243737215a4d540d1426cc283d0e21917b7043977a295f18478b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa7fd8a7d3089fa4fa00fb2055e1a92abdbc663a307b1ed8e097fdca5405db9"
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
    (testpath/"test.c").write <<~C
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
    system ENV.cc, testpath/"test.c",
           "-I#{include}", "-L#{lib}",
           "-I#{Formula["vulkan-headers"].include}",
           "-lvolk", "-D#{volk_static_defines}",
           "-Wl,-rpath,#{Formula["vulkan-loader"].opt_lib}",
           "-o", testpath/"test"
    system testpath/"test"
  end
end