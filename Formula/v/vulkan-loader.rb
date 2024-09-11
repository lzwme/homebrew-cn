class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.295.tar.gz"
  sha256 "9241b99fb70c6e172cdb8cb4c3d291c129e9499126cfe4c12aa854b71e035518"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia:  "4828b867935c6556c0e65eb959636f27bf3f2aeae6542522cf41a2ff56d37e22"
    sha256 arm64_sonoma:   "7dc17e5c77e0faace0ad57032f78d6e37883babd609be3d4888cad9a0eb53cb9"
    sha256 arm64_ventura:  "64e9f848deb14cb38be095c725e8c4cf4b893d5ad3da613dd60d09852eb4a82a"
    sha256 arm64_monterey: "42f16af9881d060ed1d16c5be0a9b96098535d16690bcf1600e6946eacc7f2be"
    sha256 sonoma:         "357bcf452c59f750ce5ec1acbfa40c098b5826abd483ff65e80a61b5e9702800"
    sha256 ventura:        "56e2e3c3a5fa5afb9a496975841b50202e7b724d6a33582d5820be41c49f8dce"
    sha256 monterey:       "3c3331db342618229e46a55a64a91a8a666f87ee091d94f9c566f3cddcf4f590"
    sha256 x86_64_linux:   "d8cd4cb1262a9d3d0963aa2cb25f118a5dfcb844e8154ccdc24161ab31750d6f"
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