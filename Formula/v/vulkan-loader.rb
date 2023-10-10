class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.267.tar.gz"
  sha256 "a5ddca95db1faa0bc3ad958d3979d063846252bd5dff1f3ed5833cb20dc0ace5"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "efedd121d1ff92dfd4f97562efd117c98069105c10f13037f483a6a4875b6f59"
    sha256 arm64_ventura:  "68fbd92c6bb2afb727c8c46cb428f55011a620ba122959975990654ee4328b11"
    sha256 arm64_monterey: "0f4372a2d0d9edd25f65c9a301fc36be91cf74f92de8cfff17f9699bdf5fcdf4"
    sha256 sonoma:         "b98bacf8714dbf2c70e34d94626ba9acb35f479660ffa1914f2ecd1e61bb29f6"
    sha256 ventura:        "b50a34eabe0e5353c76fb339effd0d4eb54390e1bedda73db573604e531cd0ab"
    sha256 monterey:       "810f8045cf5fcde635f1a6ed462ef4b4226b74bf542a0fff59681dfa38c241ef"
    sha256 x86_64_linux:   "77e92b7baf347cab671a9fc9ed97871706f2b09d3558b597f87dc92dc368e15f"
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
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vulkan/vulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end