class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.311.tar.gz"
  sha256 "bcebd281753384a2b019a633e6a81dca0e75414f0c8ec49f56edfcda8020ec20"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "9f37c926807cbb20f411245c875b6130e5975f21ac58619529894726f911c8ef"
    sha256 arm64_sonoma:  "c7c2f4233a9ea4723a1c4dd439105fd6c17265d25adcd0f2631a636f73da1c51"
    sha256 arm64_ventura: "799cf2b5262b7230bee356127dd409e98d9250890a753d533f2bbd162f86bc31"
    sha256 sonoma:        "f70ad361257e259d577cc57e1e245b0773df8d3fb8a7f31fa53433f5267e13d7"
    sha256 ventura:       "d6931de3ac96f85c6374f9322cce35af70e4808577ccbd12f57bf046a760f2f0"
    sha256 arm64_linux:   "b36c588ab4587a9e61fa1654fdf6f987db79735edcc753e1fd57390a6c147c16"
    sha256 x86_64_linux:  "89c639bab5d525f935d89ffe667903a9132adebcbec9c399848cf78a0561d7b0"
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