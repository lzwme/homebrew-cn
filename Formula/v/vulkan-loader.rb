class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.301.tar.gz"
  sha256 "7f6895bb25faaca72b9d75325f1d225ae7f30081d3e81c8c19f2c4556b23d676"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "574c0970f05a142d12d31248773ff523196a9b88eadcfc64c4f679496fcc3283"
    sha256 arm64_sonoma:  "5437078201d7c8132c272ffeae98520293c3e8f591c0cc0c228bfc53e4693b27"
    sha256 arm64_ventura: "82c1d9c15428209675ea59eb91dc027f7a1d47879a293d8434e2f0fce9e722be"
    sha256 sonoma:        "e22ca56ab3d54db966a5e2648c65a5a2ce741a97613dab8df822ace2e7fe706f"
    sha256 ventura:       "fc0e509d57ecfe89a3f4196288f9f8478c18a60edec2a99f7d34b83517b2bcd8"
    sha256 x86_64_linux:  "8f44e893453eec79736ee038ad3e63e21ba4625eeed616c10cd823a2ad229082"
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