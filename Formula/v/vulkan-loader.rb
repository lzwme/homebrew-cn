class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.303.tar.gz"
  sha256 "248a5f7dbf990609f61dac34d19e43f441ccc31fd5ec49b64e807740099057a9"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "dfdf4849f8675ce5601fd24fd4ba45e017ba6df9958d9d35b655ddffb423e8a0"
    sha256 arm64_sonoma:  "44f0ec230e2293f720359aba6d59b9a94cee5b89ed2a2cc7e05cfdf3708a3c86"
    sha256 arm64_ventura: "78dc867f4a249197a3cdbc169b0bf9550eb0c1e36060ae00592084bd5f67141f"
    sha256 sonoma:        "f8b3d8e1c097075130b80a52ab7c40da9b3ba562a2f15ddd558606e1b8dd3ba6"
    sha256 ventura:       "ea1a6d15bafabc4fa9d5b9dd55ae4c8c427566bb02a31a71953657f0ab7a0bda"
    sha256 x86_64_linux:  "b3089ec3f8c231af90a8cb4ba1eb4694dd892e4ea3f146d83c455eb7e36c7f6c"
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