class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.257.tar.gz"
  sha256 "9d6d1b19ab040a95f70f75db573080d567e41dd35a018ed9dfdffef3230003cc"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "7fcf12fc48f153ec90f5a278a77c3a6681a8c259b2fd550a564468f844274989"
    sha256 arm64_monterey: "cdf9101871b2743aaac6d017a9d99640455feeaaf783a06394cdfa79246d3789"
    sha256 arm64_big_sur:  "e72446b5d0002d22ca1709df123b59681c9b129f6e171661dc3d6edd3c8c8078"
    sha256 ventura:        "9b134bf4aa81fbae12dfe5dbf495cf8760514135df18484a1032deddac4a99f6"
    sha256 monterey:       "bed90622714330c8107c70add4977dc347c1401efaa098335fcd70d83c85f2a7"
    sha256 big_sur:        "58a999f937d2fdd97ae2eee656f1ad0aca0cfa56c88e5db84607aef9a68cfc1e"
    sha256 x86_64_linux:   "2561b22b3da2f977d70c06ff62dec9dd7c3e3bf4f9f894302d33fed266fc6764"
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