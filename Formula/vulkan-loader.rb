class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.245.tar.gz"
  sha256 "93ee2885dc8ead7b654112c8c1ebfa8e10fa486e8c71c909846f855f43bdf046"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "292a3d3410c05aa2c507bd2bedf4f1e1d662a37fcf076536588fe01fa33fa5cd"
    sha256 arm64_monterey: "f112da957c32d435fe388a64ea39076be13d9561a15b6abeecde1e44de58d9b3"
    sha256 arm64_big_sur:  "2ebfa4d5a1fb25821d9ec5ece469c6b3c5b4e458be0098a6ba63d91d584f8d69"
    sha256 ventura:        "941069930fb8f281b3492b36aed4c428691d9e5ddac0c4a7a2fe49976f8276a0"
    sha256 monterey:       "50e555cd35ac92a020716a39763fb94860f48794b1ddf14501e802132a711a81"
    sha256 big_sur:        "d1f7734f9e0c852fd5aee10aafb00bd01636ef149ea98d9a3cc8ca5b2a338216"
    sha256 x86_64_linux:   "a4bfd2a9bdb345710ffe6f9398e7d4435d6e5688b1d341a030381e10243e553d"
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