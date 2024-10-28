class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.300.tar.gz"
  sha256 "56fd9d3d8dfe97261a375595c90731a0c26ada2b20e8b7376a3d9a155ae600d6"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "754c7185fbe3aff2f40bf66c84430587d84d55f7e2793e0ee6dd3ba200ce6e12"
    sha256 arm64_sonoma:  "44e34b466a17c436d8d39b58950b9465c4d049d11c06cad0568521839a6882de"
    sha256 arm64_ventura: "f1990bff0f6ff806b4f6220c24a52fb712c81b766cf08e99059099a7f64e507c"
    sha256 sonoma:        "e1e765b8b6b9177220534af91a75b9eda7f8e205f3df13152898781686b34b90"
    sha256 ventura:       "c4477d58f80f13bd09a3c6ffcdf4e210ad727f447b12cda9c751418007290701"
    sha256 x86_64_linux:  "55eb0df406bb347beb6c90ae2f654fd395f978edfae9f70fd6847b2333e2d084"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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