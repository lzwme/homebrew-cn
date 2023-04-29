class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.249.tar.gz"
  sha256 "dad9cda73559b277e9b188f5222bedcbf39b35a201d23a2c35dba25953511311"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "3763f97618da91b90428ba9b12e89740af1a547146e2b00b7334450e4f62f380"
    sha256 arm64_monterey: "7c32e8696fa44e676f8dde5994f196e47b1f01184b911138798718c408be5dea"
    sha256 arm64_big_sur:  "bd9bcd11b8c732aadccd715d5fee83341d43e0d976158436a5c00da3b314c941"
    sha256 ventura:        "61f038599a611367da8f3601318295af843c7cd54bacb1995961c4a1b78860ba"
    sha256 monterey:       "6410d4dc06502f5ff450c2d510282df72b2e23f039964532b99dd25f9984d990"
    sha256 big_sur:        "080bd5710588ba9566dd1a2235d605a3d7acd0b9ac6a6536b332319b132400db"
    sha256 x86_64_linux:   "e2e3e01fc0c1878dbf1a54b4cc994c5ddcf557b5e3f45d713eb0155287998a80"
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