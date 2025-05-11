class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.315.tar.gz"
  sha256 "2e7c3762ce0ef6ba35e319ca270f1714c06e02c0efca145a1c5fbcc4f79fe59f"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "0455210ef4e4353264dfb7ec09e976849d4c0c6972c06ad649c65df896e39f13"
    sha256 arm64_sonoma:  "07e31cbbd92ae92fe84d38fb61c2085ece8ad8a001e6ff0a34b56a9311135c65"
    sha256 arm64_ventura: "770b9fd325f4662b432699822be2604f7bf2fae50f6f47c1dd7dcddb73b87f07"
    sha256 sequoia:       "d3ce67754d2675ecade1138641de023afb727035edabf6bbd23d9f9fddd4403e"
    sha256 sonoma:        "94c30eaec50d6a52782e59bbd88cbd5528d9f698ec697c92983d3a4f64ac83b2"
    sha256 ventura:       "ff43bc6b2dde9a5160c1c42c50e0c430410b84db1cd200ed393631321b41c5df"
    sha256 arm64_linux:   "8437afe28588115823f7fe2d072d7bcce3e378da62c64c83ba81750e7899697e"
    sha256 x86_64_linux:  "05c1ec291015aaee957f6ca7726a63b06b5219ca9c6518dbaf35111860ad8626"
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