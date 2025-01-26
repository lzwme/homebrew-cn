class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.306.tar.gz"
  sha256 "983576dd502555fa1d5bd157917febf155d10428dd27cb89bce91bece48c6d07"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "58c3a4336169fd8b120671c2cefb22560c8a5d6817d1d3de650da5eeb919b4d7"
    sha256 arm64_sonoma:  "72ee51362e179399e553781aea21bf187fd3e858474dbbfe9e2bb0f200d9da85"
    sha256 arm64_ventura: "2fb12da5669e8ece08edd4571b68aac414cabf0da24cf049f0b4b6c919751d50"
    sha256 sonoma:        "f6f7248db012c9f07c905133e593d094eb688a0e75ee022da5d3a4a41f240119"
    sha256 ventura:       "f361d71d1539994a0c1864e1c81b1a210719c0ee8ae397119f77cff58ffc96eb"
    sha256 x86_64_linux:  "004a4f0e52676b68e556838f9cb60fd593662f982fa98a41f5022d1a14066258"
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