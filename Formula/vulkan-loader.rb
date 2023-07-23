class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.258.tar.gz"
  sha256 "2617f6930dca61af296ab075c33bf144a7e2d6369b595effca845dd14d3b9b91"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "a8261e7b243591f7da2e1b22707e8713bca583eaaada51403ab730ecd410d313"
    sha256 arm64_monterey: "4e92edf249020708da5b67ffa8892975e2f77b7aab946f49c15b77c95fbe5ccd"
    sha256 arm64_big_sur:  "22afb6edc3b9cb273c9b751b27c97d8e3078f06726945ff17667e496dbe55ee2"
    sha256 ventura:        "84842628ecdbf69a48e76961e5713800e5b459246973700dd102dbd0a7aaa93e"
    sha256 monterey:       "f430e7bd7b48dfc6b75ffbf8a49551ee11ad082955dd7639fed52af449536c72"
    sha256 big_sur:        "ba57f82ca22b38aaa12fff56aae30765b58b2b2c673b73d5efc534f4de928e15"
    sha256 x86_64_linux:   "110617702349b4f1a0900887519a7c5c7338e762d2f32f4792e1e8b1fb2e3faa"
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