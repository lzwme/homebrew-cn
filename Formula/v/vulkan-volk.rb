class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https:github.comzeuxvolk"
  url "https:github.comzeuxvolkarchiverefstagsvulkan-sdk-1.3.275.0.tar.gz"
  sha256 "b68d24e139190e49e5eafd72894f6e85c80472b8745bddc6ef91d6bf339df813"
  license "MIT"
  revision 1
  head "https:github.comzeuxvolk.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04cf47cbcca20d9c58399f04fa0eae49d2a1e259fdb57fde6ac453a332f0b729"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2403f2ac2b2722ab8dc3338bd9dad0b3fa356fb065a13e96cfcfc0e22fb2357e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e244bad5e8cc1ee7c01fa922479827fda9a672b4ab37531e944d12e232e1e29"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f13c21a5ee6909ca5f18bab55e4882ee171aeeac44357b74fd9d15bf31f3d13"
    sha256 cellar: :any_skip_relocation, ventura:        "64abe9da2a2a5624ef9283b76c99d59af9308312678cd9c51198513d521e7bd1"
    sha256 cellar: :any_skip_relocation, monterey:       "a32d75ca18ebd7776cdad95d73d5e9c66aca5b59f863af749c50b4f9121200b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8338f72a48deac1879445ee2c7406686c1b9687fe63ed9bbf5d08f78f7a628"
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
    (testpath"test.c").write <<~EOS
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
    EOS
    system ENV.cc, testpath"test.c",
           "-I#{include}", "-L#{lib}",
           "-I#{Formula["vulkan-headers"].include}",
           "-lvolk", "-D#{volk_static_defines}",
           "-Wl,-rpath,#{Formula["vulkan-loader"].opt_lib}",
           "-o", testpath"test"
    system testpath"test"
  end
end