class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.254.tar.gz"
  sha256 "5057ef73468b38c7d91be1637b5cba46d5d6c798589a161f46b015bcf15481d1"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "38d88c649c034f439515664160fe3aea8322c3d7e34328b9bb481c68cf7dec4a"
    sha256 arm64_monterey: "43323d254d16ab071458411b4d2eb41b7a9dac90c6a4cfa9db93405abd2b2a22"
    sha256 arm64_big_sur:  "c84f6814f6c436d9356cc92069fb101d27ff8bcb18623a5975ff43f224535874"
    sha256 ventura:        "13cc004dc961d2469a44179c3d53db779fcf1521e88a52c6cdd31a4a4e644a2a"
    sha256 monterey:       "33787f7e6c3be75bc933576e4fcb7d34be520fd0490e94f6bb45a8bbeeb03dfd"
    sha256 big_sur:        "a0fde3ee5506ad9a725bd46a88d86e2c2815c3d9e48ffadd4061587f4114f297"
    sha256 x86_64_linux:   "4fff48c41de8e4a544a40bfefb9c21e08281f82620471c3071a003436d49c968"
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