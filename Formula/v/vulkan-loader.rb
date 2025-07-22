class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.323.tar.gz"
  sha256 "12b2bd3ec8a61fc939156ac45a82b889edb02262c021798f1496c983ca8a528e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "be391d9e7df459f65bb8b173ab0c70d6ecc3639ad4adb9dbad85e3d4082a88a9"
    sha256 arm64_sonoma:  "ffab6c1d9c7a2a1d690df6d0fb2ab46460cc54d5506af9bfc568faed76bc71c9"
    sha256 arm64_ventura: "4ebe1660f42c4baf0d689d3703cdd9b61337e636e4a87b5c0eea6d1476d4fed2"
    sha256 sequoia:       "fc26f3eb2920510979c9e9dc2b154ed742bc0d0f0b85b697b3f4c353dcb2b659"
    sha256 sonoma:        "6ff060885611a4e254800a7b7cd34a8ce9668e1fccf7a9ff4e2de46c791ec3fb"
    sha256 ventura:       "44e8b7509a89d1cb61a10937484510633cc8eea47c5a4c2bf83315df59bbe494"
    sha256 arm64_linux:   "12280f10bcf0b1ace296d2f24f69f1a229ac5580d4aba5ec69b184434885751d"
    sha256 x86_64_linux:  "65cf771aa5056b51bb3439e1d580eb1357d7c67b0ab9eb4e444f74ad9c66826b"
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
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vulkan/vulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end