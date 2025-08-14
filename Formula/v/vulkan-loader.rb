class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.325.tar.gz"
  sha256 "029f58547cab96eb7b2c2b993e241b69635415c49cf8f8e7a610ad9f1ee3ce73"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "4e8de2508cfb9fc1139d9be50142ddd0ef34ba826e6b5a46a51db72a91129001"
    sha256 arm64_sonoma:  "38fd14f3e4b95c255b1430377ef1e20b4fbeb2b34cc5bad4122279c8ef309226"
    sha256 arm64_ventura: "da0a985d018e181ad2285e7514c75a5b224aeed48cd1b22175cc106579c7fbc0"
    sha256 sequoia:       "6b13fa3c933e2f1b0f5823d6fdb8b839a34300db0af7bcf0af210227d6be442d"
    sha256 sonoma:        "f592e362fed13f7bfe0ce8c09f0b2a735a5bfe91d071a3cb37babfd0ab0027d0"
    sha256 ventura:       "60d5c03e6be77293098f42c2716407964277a521d7646368eb2c048714b812de"
    sha256 arm64_linux:   "af12767f5fdc8603fc24255de8a062c418585feebc9f5c1f009bc88d1fd58ee3"
    sha256 x86_64_linux:  "4c2503d19ee5008a176548360a8249db5cbc9daf016e90b8d14b4d9fa9df1add"
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