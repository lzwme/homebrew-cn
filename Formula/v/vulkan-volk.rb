class VulkanVolk < Formula
  desc "Meta loader for Vulkan API"
  homepage "https:github.comzeuxvolk"
  url "https:github.comzeuxvolkarchiverefstagsvulkan-sdk-1.3.283.0.tar.gz"
  sha256 "872035f1f26c53b218632a3a8dbccbd276710aaabafb9bb1bc1a6c0633ee6aab"
  license "MIT"
  head "https:github.comzeuxvolk.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "514be857df8081574dbf2e80afa62c2b87488e3c5f99e2c89582e37f26ce7cb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0760d61ba6fa1e97cffbf0c35362c8faa56f88638c8a134eafb4a9e878abf779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f06793bbb21a54d7c9f959d97df51ef422b1e13b6d8cd28e3e27fcf712d9d74"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9c2878ce97429fbd687482db725b24f3ba42ad181dff926b605ef3d2a578308"
    sha256 cellar: :any_skip_relocation, ventura:        "a0dc6361ff5d90d177897312884ac4e67408789b41bf1cc9f233f8c1ead9ff4d"
    sha256 cellar: :any_skip_relocation, monterey:       "46f92cd3cbf0c97913bd78193eab71b4b98f5f8656c9bf022752ef6adb82cc52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfdc6d4d0cc4add34a691395a410269f193f5a8d052649346837427fd227b6d5"
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