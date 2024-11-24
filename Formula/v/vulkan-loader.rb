class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.302.tar.gz"
  sha256 "7f8d3e5c7428fe2d6220a4ea1c0270c7695bfef8e48c38b827e9e81880637710"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "ed1a98ba55f7dc0da2838514bc725d07dc721b2a9f100b55c10be93b354443f0"
    sha256 arm64_sonoma:  "dbc1a372e9889a0dade988988da73c117100aadd456cef64baae936637b30b01"
    sha256 arm64_ventura: "4fa1e7cfeb7f58a731bfcf5198886c63ab118d4cdf4be30bd30c07308d6aadb1"
    sha256 sonoma:        "62c2abe8b08cb43c5b1e9f1f755ce8631d8b8d8661d4f68aa0370fd41dcc40d1"
    sha256 ventura:       "5d7b44431f56e773fc468ae14e8bfb47386034c3e4517ae590aea7ec8996a827"
    sha256 x86_64_linux:  "e2673dd8f9322c4dfd27a900b9e932608d909dc8dcd239218dbe4675cfa3e29d"
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