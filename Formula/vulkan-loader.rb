class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.246.tar.gz"
  sha256 "2531b6ef63b18040e5b0a3aa56df51e6e3cc42e7314c67a88a363be4c6975b2f"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "3934a7709e455dc7e3ad4ff3cdff78d9ee760f97be02e69a6150d6b4c2ed3b26"
    sha256 arm64_monterey: "3eee6f368267921f8e2d124fc5a09bbe71c661594cef9d5249c3ada43a83a2e9"
    sha256 arm64_big_sur:  "ea1045d2291a973583a6144497f6643e2fe870fd1f8ca55e8e1befef5626dcd2"
    sha256 ventura:        "427345ed9ccf260eb5eae57ebcdb831d6337743c6d0b24e6e60a7c7b0658e0da"
    sha256 monterey:       "d4258e4c77875f6fe7138933c984268e27547d06f862dafc17e8c66aeb796e78"
    sha256 big_sur:        "4adcd80da4cbf4e1df5adcb3a5c40c2f03caba164398aa49b2d76a2e1c48d6eb"
    sha256 x86_64_linux:   "a4fe31a6c62091f41221ce47c29fbb6dbcb820524dda157996e5966b46b51fd7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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

    inreplace lib/"pkgconfig/vulkan.pc", /^Cflags: .*/, "Cflags: -I#{Formula["vulkan-headers"].opt_include}"
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