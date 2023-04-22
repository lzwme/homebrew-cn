class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.248.tar.gz"
  sha256 "5a5e51c568ea4344fa93c562eca730359a9562c4656dad53d2cc3f4807ec2307"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "85786b0b05cdf44ea0f362372d1c6a5754e2baf01a8bb57b2c3ec8d9e4be4987"
    sha256 arm64_monterey: "211176945e04e4a0340d16169f30f26f9339bfaa3a86dc0a4084b34c652ff300"
    sha256 arm64_big_sur:  "88f14e1301bd86a07eafe8e712fe3ade2905c31101414c6995b6aef0f6251962"
    sha256 ventura:        "50bb8b12c506967d8d554e454bea6fec8855fae2f0167a57e813c2ec40d90b34"
    sha256 monterey:       "2d991f492c3c4da0417fc1dc2948e2c81c9e464f422488c7730db76de0f62a9c"
    sha256 big_sur:        "ce9116e09eb6c2170803c9dc0d7682133f353305e55097f1eca8e9c24d5eb365"
    sha256 x86_64_linux:   "82da54fd99ed0358f9de305df231b3d8633eda9e0eb2b5b54cc839dc7220f4fa"
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