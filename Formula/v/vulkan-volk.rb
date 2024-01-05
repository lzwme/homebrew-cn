class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https:github.comzeuxvolk"
  url "https:github.comzeuxvolkarchiverefstagsvulkan-sdk-1.3.268.0.tar.gz"
  sha256 "f1d30fac1cdc17a8fdc8c69f371663547f92db99cfd612962190bb1e2c8ce74d"
  license "MIT"
  head "https:github.comzeuxvolk.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4fdcef8fed7247cdfb8ad61b3c04675436222954c1f81a92f0ea03ff44dcb4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c87c61104f73c14a0e31c035fbfe90eeb2e240ebb5cf320898c3468521e914ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08cf920caae07d2556e693a8f50215643ea7ed078dbe7ff47021fa698cc19834"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddd12208adc49f14e8f1169159ad7dc23e72ffd6730a855a1619931d4b32f60a"
    sha256 cellar: :any_skip_relocation, ventura:        "193c7794eb88c2b178e3d7e0920b50d383ec1111b55481a1419b804b33c29756"
    sha256 cellar: :any_skip_relocation, monterey:       "b12d48405694e5e1784737af790f9e06e6914d8165065ab825bbd07c67e61065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7664ad5471681baf6713b26beb11a49efc4b3a54ea4b8b2b74c3e36b541f3023"
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