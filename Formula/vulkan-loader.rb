class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.244.tar.gz"
  sha256 "5326cba17c6b567d369041cd4ed7ef46ad8ff0e9b5240a51b1dfae28516979bb"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "4f87bbbac12aae673c55109e41229975d1a109d5eb9194c0962ac6ea393d8e44"
    sha256 arm64_monterey: "860a9b482b548d56d951d491e5b973ef748b52514af264b4e8836a3e38208185"
    sha256 arm64_big_sur:  "62fd99ed5113af5b493393c70f71957f9150f30b708899608e07b1d58098abcf"
    sha256 ventura:        "e1cf7a68b61dabd0bef7e64f38f523d810b88ee84493e6aad044687f504484fd"
    sha256 monterey:       "514773e0082032cc28c0aff7d32cac79acca3d13076cdf7f8487fa5e827bc3c9"
    sha256 big_sur:        "fe483bac4e30cb128c5d6000457c9f31413cb132a684b0319f5a9bacb99da764"
    sha256 x86_64_linux:   "ff3d5a0573c008618bc592c9ddd9224fad77dd0295356416b9cfc72fcc28226d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libxrandr" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "wayland"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace lib/"pkgconfig/vulkan.pc", /^Cflags: .*/, "Cflags: -I#{Formula["vulkan-headers"].opt_include}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vulkan/vulkan_core.h>
      int main() {
        uint32_t version;
        vkEnumerateInstanceVersion(&version);
        return (version >= VK_API_VERSION_1_1) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{Formula["vulkan-headers"].opt_include}",
                   "-L#{lib}", "-lvulkan"
    system "./test"
  end
end