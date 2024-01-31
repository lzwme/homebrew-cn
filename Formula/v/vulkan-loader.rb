class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.276.tar.gz"
  sha256 "64ba124f38b151195e68326829eac5173e05734c518f8111e5bcf500ff898c49"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "b38f204943e19d2581c13e4c2bfcb0dce78f5f893f61333074341b4b75877630"
    sha256 arm64_ventura:  "10f637e682f6dd543a5d8d27c8995922e06b571928c41df78b953eb812fdd301"
    sha256 arm64_monterey: "af86260d94711f6faf27b354cc7132776baba13e33858176cd4d3fbd49665700"
    sha256 sonoma:         "435401d3a027f5a00cd96f70e8a3816f1faca8cb4e02088bc969750d6d54d6b8"
    sha256 ventura:        "39f4fb3d8b75d0deb13394983bc066abb18d325406c817819cb738ca45bcff87"
    sha256 monterey:       "c96c38a4b1d60c930e11a18e5ea3ff6f57ca97689319408d7e5a7d40e923b86f"
    sha256 x86_64_linux:   "cfcaed66d29f6e0b72528bbfc395e70d01e24404d7d639531b505103d7bcf6f3"
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