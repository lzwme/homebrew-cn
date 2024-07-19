class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.290.tar.gz"
  sha256 "a1f0d80c4ee448d4fa37d1d4a4c4cf1d6d0f5873d3ca6dffe2a9498e6e654142"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "5546a17c67546488bdf9b3a9989378657dce976e71bbdff67946386d23f118a3"
    sha256 arm64_ventura:  "59fbe1e5db153db1ee06c0df9a9567897ceff469319aef021afda2d87b4e77ce"
    sha256 arm64_monterey: "17f35a40a31f4b279150b079438025e19f0c67c66da16f39a0cdfa5fcb1843c7"
    sha256 sonoma:         "3bbcab0e1bb6762280d846239f8e961ca54b6cca7a8550929269eabc34912c7d"
    sha256 ventura:        "ac0cf69e3070a4939bef7b308bba88f1a16e30f7a99e7397b11ea2d126941b20"
    sha256 monterey:       "f8081cb4950c3b4686d6ccf69d9563917f2d41982a66a5adec3be8ccb9bc27b2"
    sha256 x86_64_linux:   "e166944691d06318f5d484a5ff4138664a703a848f02b75e2d2531533944ac86"
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