class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/vulkan-sdk-1.4.328.0.tar.gz"
  sha256 "658f185c49692e21833505c01b792d86295c4e41b0fd500b17fc68c486edf1ae"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "6dd23ab3d59191139a9a23df5e452999c8e8c334b3132432b18a16fe29137fe1"
    sha256               arm64_sequoia: "d2501794666139599c48f912e83e71fa913a2935a1f421b72646f3709bb3aca8"
    sha256               arm64_sonoma:  "882da10559be841eec51e79301d1407b192e15273dc9e4075b12a800841fc432"
    sha256 cellar: :any, tahoe:         "daecd691dfa438078c7477b1515bad41161dbe85e8bd7d28f9693791b1df0deb"
    sha256 cellar: :any, sequoia:       "1c9be6c58e39108f4501f0fc3e7d644307d608cbce984ec91f1a178d275ac7ee"
    sha256 cellar: :any, sonoma:        "93e0d18342fb8e5cc46ba44c7bad1c689260cb29cf48f33baa2c69b0aca9f063"
    sha256               arm64_linux:   "b45af231ea083ed3d085ae4de9e6df51cde67521ec69658ee4ebe637f1ba6c80"
    sha256               x86_64_linux:  "2a02e0961300fc7fc78e48037c6d38d59f77d0c76bc6f961269b6527d188c8b4"
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