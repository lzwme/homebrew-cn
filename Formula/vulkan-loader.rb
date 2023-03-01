class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.242.tar.gz"
  sha256 "b148796d2aa5c8e655072ba985c968eed65d91f8d4fb8146919c3577bf725bee"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "5cae080e450c7bef4784be5bdfee8016590c7a6dd369c9e931b04a8f92088a17"
    sha256 arm64_monterey: "e9a636c79d2699631e36bf6747804fb6090042f6f96a2624645ee7c7123512cc"
    sha256 arm64_big_sur:  "cec577d1d879a9af4e762e65e318a780700a844873c3a9ae8f4f8b8316cb0f7b"
    sha256 ventura:        "f3a8ad6c163ff4d34258c79dffb4c563443345db719db9003bd0155e1ba32b89"
    sha256 monterey:       "272d5194d417e28044aee02926ddfac9b19674437c4a1f4cd65696147553799d"
    sha256 big_sur:        "f40afcf6959655f00889e339ff6d8a743da82e68bf5cbcf9d39a4f609a200140"
    sha256 x86_64_linux:   "0fa3750e340045d8dac7d0d0890f14b689e435ae5289ea39610ec901db1a5ff4"
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