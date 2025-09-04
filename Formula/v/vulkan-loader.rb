class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.326.tar.gz"
  sha256 "86772b60eeef6f510586636b7cf7a0e0eabd9e9920bcabf6e8f3b1c2a634a4cc"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_sequoia: "2b3d377d43d59f2576e136e706395c6c64dff5e077fa43c4b0a921b615f635a5"
    sha256               arm64_sonoma:  "02cdf6f5f443acdb9fc7684ee59fa6ed08c8a92315dcfec18351e0c6cfc85c72"
    sha256               arm64_ventura: "4b6c12ca6de39603464a9f04cfd27ab7eb17ec0a8f95e2f472c33c468968a556"
    sha256 cellar: :any, sequoia:       "ed9de26d11433881f00e9572d7efe2cadf6dece8f520409e6526d0948660fb31"
    sha256 cellar: :any, sonoma:        "a5c5ca977934fd1c93386194d44066d151f1512b6329d8bffcd1a70eaf823e54"
    sha256 cellar: :any, ventura:       "6cfb1455dbbe117736114fa04fe097c83d6171d34313ec57812624f1fab66d90"
    sha256               arm64_linux:   "2565480a9902ab3d3654324ef86dad5654921fb9a51e97d0483a8e503904b05e"
    sha256               x86_64_linux:  "87d668ca6646b0c3b3becf15e62d19a80a9699bccfcc1ca1d3e94f4722c08e4e"
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