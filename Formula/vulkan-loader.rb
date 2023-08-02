class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.260.tar.gz"
  sha256 "95b42ae51c987ff3b91b7b08ef3409c7b0401fd1fe2505579cd7042a3cef4726"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e1451d22bcda02cbb20332a234c4083230e59cb1fb3c48d8b53782983d5c7b35"
    sha256 arm64_monterey: "b03d0fdaa1eb8e66217904397e982f51678e6afec01ef27c5aa7f652ff845516"
    sha256 arm64_big_sur:  "4ef1a36098d91f0529923e890da7e26ad13f86b7cc65965a2a7b0b699793ded1"
    sha256 ventura:        "dce6ad266977e08818ee6f402edc9e242aac030d1e4a5f29207afe26f14a0142"
    sha256 monterey:       "2b76025750874490f1772dc57590cdca65b20e580f84f814b2d203da622d7883"
    sha256 big_sur:        "cf5db9748f451e27a1221fde00a6e42acec0ced74f50e68d997726457d685d8b"
    sha256 x86_64_linux:   "d677f18874fb78e040b9e11af475f7227c4d6ee3559befa22fb4600c1fefebac"
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