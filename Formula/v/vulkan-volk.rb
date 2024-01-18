class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https:github.comzeuxvolk"
  url "https:github.comzeuxvolkarchiverefstagsvulkan-sdk-1.3.275.0.tar.gz"
  sha256 "b68d24e139190e49e5eafd72894f6e85c80472b8745bddc6ef91d6bf339df813"
  license "MIT"
  head "https:github.comzeuxvolk.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "161ad19977eb49bac1f489db2c9b684340878964d2b547fdd7bbbf6f7cd4bb92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eec66cc2869627fd012877dc99c4d7d66866f6a4538efd3b604f0947649ac72a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9606929890dfd4f837b0291a66c59c00a63d89b6752e08235d0d4463396df326"
    sha256 cellar: :any_skip_relocation, sonoma:         "f20c4450ebd2831dc50a8868e3718bd2ada3df000121b223a33da1fbba0495d0"
    sha256 cellar: :any_skip_relocation, ventura:        "d42ec3e1f6b66ac9650e5b88ba8bf0c1abd18a46935fafda792f11f89c87b095"
    sha256 cellar: :any_skip_relocation, monterey:       "70b7770ed0f9576beb786b4215e0bf0b8e112a376e9e13520aed0dbb7e0e0a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d2af0bbff192c954b16e22ab8b711062c1aa3c1cc3ee37be941043c9bf1f31"
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