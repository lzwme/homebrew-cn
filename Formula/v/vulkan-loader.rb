class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.289.tar.gz"
  sha256 "93897b1a7c5a5d69e3346ce176379f00e12223658b204651c79348ca8bec29d1"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "27297bc74424078e98cfaf17e4569c136ce15a746b0b140b7b5efdb8fb58f8c6"
    sha256 arm64_ventura:  "7b52b891fb48aa5b32b48cf650e8131b217d41beb7688f2020bd661e98f5626c"
    sha256 arm64_monterey: "e57b4b042e313b7bcd342f824b3597853d910908284dfd69cb4c6e587738b4c8"
    sha256 sonoma:         "7c928f00c2c51295ebc71d26c0bd22103aafa02815a5d019eba73cb9d5d6a7bc"
    sha256 ventura:        "75e134467dc94edb042a5cd650cf69caee87c03c6d595ff298cbedd6cb7cd657"
    sha256 monterey:       "a3098fa5da320ad37f55db45dd0d270929d50da644c13307c0dad4bf9185b4ad"
    sha256 x86_64_linux:   "e6438396992850a760956973fa93483a13310e8359bb73f0d266bbf4dcaf731d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libxrandr" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    "-DCMAKE_INSTALL_INCLUDEDIR=#{Formula["vulkan-headers"].include}",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}share:usrlocalshare:usrshare",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}xdg:etcxdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <vulkanvulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system ".test"
  end
end