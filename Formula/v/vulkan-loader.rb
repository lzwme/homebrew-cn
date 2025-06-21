class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.319.tar.gz"
  sha256 "6f0bd0079c56518db0243854db822e39ba25602fd24cac34b6f43b75c764e743"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "fdd46b86990fe224b691ac6a1a957fd347c54c8e22ebef7109ff98766f4207cf"
    sha256 arm64_sonoma:  "e1cd10cb4d02aa8cae004b8f18b8b9b6de71e559180a6569bc5265a5cf1c44ef"
    sha256 arm64_ventura: "2aaba62bb1a002bdd5420cadec2c6f01f51fac1ea400ab8a804c5c1fe8625f35"
    sha256 sequoia:       "c54a277402559f933fae4ffe570882caaaffa1bb2ba9e4c391f1012b19dbbd0e"
    sha256 sonoma:        "8f66092ef5c37031d1ca10476c075808468b8fa61056f4fdf8983b9cc62b8235"
    sha256 ventura:       "5e8cedfd02469495be333ad59ec60189dac0e0443ce7fc2325920e716ec6c86b"
    sha256 arm64_linux:   "996622308b40c23a61dcf2cfc011aace891e75fed1e87274675a2d013c8239b6"
    sha256 x86_64_linux:  "72c428076dcdf1aaf80044b662abc60b75fde7fe816d6ba598c018276757e151"
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