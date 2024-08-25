class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.294.tar.gz"
  sha256 "22933596b3b4b204800193426ce55364eef194705ee29e3f18c1f567d958e33e"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "315d597c1be8029db884839eafa73d27c9edfc32ac120306e3b51c3f1dff454c"
    sha256 arm64_ventura:  "85e36a8cba797bb6b442f8548ec05daf9aa7ff09eae06b6c763d80f2c55e226d"
    sha256 arm64_monterey: "a74a728d426f461a42d29582c7bce55f9d38d7c8b50f5dedf9df30ebc63eeb1f"
    sha256 sonoma:         "18461f778ca536d8e83dd66bcd5ce31b8ff3de95ba7ae698ee81c6e41e68feca"
    sha256 ventura:        "8a9a6ce5820e01d233374205b26d3d1f2a8c2ac0eee0aa40aeb2a1f225db566d"
    sha256 monterey:       "eb221bfeac3400e62652eb506fbfc474266f25e9b41d8c08f9dd09f67f02febf"
    sha256 x86_64_linux:   "352a8683dc5b26687561abad0722e13b3d4e4f55763344c14ded2c984834b2d7"
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
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}share:usrlocalshare:usrshare",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}xdg:etcxdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <vulkanvulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system ".test"
  end
end