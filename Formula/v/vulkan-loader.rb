class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.296.tar.gz"
  sha256 "682d5323cf31308402c888599b375ebf15810f95d6d1a08ad2f525766becf99b"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "bb1db26a18d160c120fc3b0e6f516277b416e5cc21c2d246a0bf61e82251e74b"
    sha256 arm64_sonoma:  "8e64323c0c5cc9c909942caca151440355d4a1228ac4bd391110e30a2cad9b65"
    sha256 arm64_ventura: "154aba38ed222a67c79b112e011bdc09ffd20756544cb3479e8dea6007945265"
    sha256 sonoma:        "c877ab9f6816e55c400c051c028656fdac75c7a013bbf99e6062171480bd3410"
    sha256 ventura:       "821dc6a8afc92d7a8ec70ae1fc7308234db5c6a70401f97fc444731ac5229958"
    sha256 x86_64_linux:  "fb9a1e8732283eed062cbb3e018d4afb722935c71b7ac22523866fb0c92043bb"
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