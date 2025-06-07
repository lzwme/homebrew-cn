class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.317.tar.gz"
  sha256 "e4e18585fe902ee04e86c1cdb2996b686bffef2cab02cb6079221fe69df05af8"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "6b68046591825e55a57da1342c3402d16e072a0a42d1f9574b6b924393b18903"
    sha256 arm64_sonoma:  "64075ff17051fea52318f979fe5aa47e1c509a5ca78286dfe98fa81b92530bb1"
    sha256 arm64_ventura: "409f9edea825a3ae7fe3e0853e06bfe21fc003c08ed2d4a9d799499ba413e12a"
    sha256 sequoia:       "a12b22a615d638f6cdaafe0c59cd92f5a6bb9ddb6c66e70c0bdaf89e93d42cd8"
    sha256 sonoma:        "e759b48895483d85a1768855b938df37230bd0fdc3775f9cb38a3cf3cd4f67e9"
    sha256 ventura:       "559d25b20f47047bd2a7faa644f250416b20bb32db5f992527efc425894e37a0"
    sha256 arm64_linux:   "7e48a4655ad56196adc1ba89e1bc0342eb84d7225112adaf7528b363f8afd3c4"
    sha256 x86_64_linux:  "6a167417978b4922aed5d0fcc769c00acb94610e2e44f2c44aca9ebee9b642f0"
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