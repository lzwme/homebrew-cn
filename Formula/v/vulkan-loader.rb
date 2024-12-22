class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.304.tar.gz"
  sha256 "368d8281604a3f4dee038bfcc55c44e305031ec67f6e3fdd50cdeb83586c99f9"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "d35c80b23b6e2bdfe103466725ea523b1202ff549c3687ccd046aba6dd6e6bff"
    sha256 arm64_sonoma:  "4d44cc07c46042c54a382671a76870cab6455f33f657e3814191a069d391b2f4"
    sha256 arm64_ventura: "4518fd3017776d204ee86f433bce70da6b2a36275832f81c3b247dddbd242b75"
    sha256 sonoma:        "5a6427923ea32d8e0395d57a793341d97b11f345075434c3fb59263cfeccbb91"
    sha256 ventura:       "59ce83160e137f5dd3917b2da074f0ac02219e23f68303477c67b131a1020817"
    sha256 x86_64_linux:  "c35a330ed03dad3a49eb9fc735294ac5a6d400e4f4fb04d35332bc9442720c4c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
    (testpath"test.c").write <<~C
      #include <vulkanvulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system ".test"
  end
end