class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.309.tar.gz"
  sha256 "3e4085a55f6e356fe9dbd47e6dc762be732790add3532943da824b3e8c062827"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "6418fedc3893c28d221816766fa869efa14e79df736b72e5695c1997fb5bcf77"
    sha256 arm64_sonoma:  "65beb10baaed7ab6d1176031069781b09845d52eac39671ab1261ed4329e8eb9"
    sha256 arm64_ventura: "fe1b28444f1b37cb5a5d2d238862928d24700e84ebd99b9d093afcc635a95733"
    sha256 sonoma:        "94e7b2741eeb52a52ca39f298b05169785fbab17dc228a45f733eeb2d8dd776f"
    sha256 ventura:       "74cbd72e50183a776ebd2ec248a7c4a2b5bb213926a42fc13287acbc9aec5994"
    sha256 x86_64_linux:  "930743c07a80cf22d923b0597eb526f1088844eb599a2d8efdfa5c02f46c0cb7"
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