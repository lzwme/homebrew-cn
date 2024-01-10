class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.275.tar.gz"
  sha256 "96dee7d8ccb08f2518e2b82f7a8ce84ffee511c96b16c83259fff87b6ee45232"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "089ca582882205755a15d3fb01200dc6e97666bfd6f6874cfb939b564d7193c4"
    sha256 arm64_ventura:  "2a5c5534c0fccaca2c4f04f2b543fd13467338fb14b8be9a9423c8daa16f07fa"
    sha256 arm64_monterey: "54c61d67a301320aef72dd41875808464dfd048d67cfab92908352a785abcc5e"
    sha256 sonoma:         "eefbbd84c93c3dbe815c088e29ccf41b6abc8a9d2210ad8a08a783b47c7cfddf"
    sha256 ventura:        "3c4694d54813f311a539a5792a558b44966c972cf1934bc4b82f769b4bddef92"
    sha256 monterey:       "95901a03d41118eb312cc670a9032bc09cd824348a8ef643f19d22de15326feb"
    sha256 x86_64_linux:   "ee70f7b511cbbb0f51926dbb0d733a80232bb267b15b6cae37e24346f0af8e60"
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