class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.310.tar.gz"
  sha256 "e1bb7389feed5c2c5c729e3ef3cbd426346f46eb8dbed851e5d828f9cff7a0d2"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "fd0e2c7cf8f7ce91e01e9278150be3777f932ce3a1713b427533c308a1d899f3"
    sha256 arm64_sonoma:  "ad4952188be240f1cf17890e3da9e7bf86659a95df6a6fa54413b4a931eef498"
    sha256 arm64_ventura: "2c44e0cab3d1f6b43ef596c8c6d1348ff5a619a40b5471f09d208d99eb8764a1"
    sha256 sonoma:        "32350eecce7b04030e5b3f2c5c906bf91cdc5c43ba1602cadace660705eb7c45"
    sha256 ventura:       "467630cd95b249ce137319714797fd74fedca216254a84e48d23056458a66e97"
    sha256 x86_64_linux:  "72daba4f0322b22f662b8695b909b0f233dceb56b22368caa4095cf216971348"
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
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}share:usrlocalshare:usrshare",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}xdg:etcxdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <vulkanvulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system ".test"
  end
end