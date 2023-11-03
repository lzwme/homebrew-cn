class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.268.tar.gz"
  sha256 "bddabbf8ebbbd38bdb58dfb50fbd94dbd84b8c39c34045e13c9ad46bd3cae167"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "16ae080c10cf1c2cef4b55f2bca578b2f6016d83ba53b1a556fc78a86e56327a"
    sha256 arm64_ventura:  "8572f377c8f6a1b25c674c2130a3b0686f919c223ed0488d3fac6b98a5fe0b4b"
    sha256 arm64_monterey: "26b1a9382239dc79df05c7b4a9ecc3bffb80d00d96b77d7bc579f2fbd126ee43"
    sha256 sonoma:         "f465427ce384aaf52b73f1c5d4bfce2be8117fb94828e9be13f2d23091fc97a2"
    sha256 ventura:        "dcbd8555d61006e3bb0f2933cf2fb505cbadcbd49f9a8c4620c88b3201cf2032"
    sha256 monterey:       "d7e07703454ee86763f5611c2dd55f3b34923a0ca54156d97f19ea4a955679c3"
    sha256 x86_64_linux:   "636845468ccf4efa2cda2a4ca36f3d2fc4deb22424e34334d1e77de0c254e481"
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