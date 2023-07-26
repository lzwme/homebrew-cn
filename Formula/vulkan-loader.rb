class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.259.tar.gz"
  sha256 "7e0a6fea6b45eeaa527e348a9a9799aad7dc7c5bf35f49fc0fd48ff54c26398b"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "c23b5a0bf8551d1277f00061c35fd4da1e4f2b281f679199a4839e1b994219fb"
    sha256 arm64_monterey: "8d573057bb2a76344bf9b1c7379891d6bb15a25938f69f2b8c6c7fd9ae06ebf9"
    sha256 arm64_big_sur:  "7e4c67ac049b0daccb1bdb136fe221a72c368e242ce267ae5cdd4feabd9a0960"
    sha256 ventura:        "1915d4200a2c3faf6f69716aa3d8349823c24f8ca5a74f4a71dda242fc73a02f"
    sha256 monterey:       "7c28216daed76498b59d76a1cf438355e0eb433fab20c7c300997ef1bcd533f5"
    sha256 big_sur:        "2084b51be931e5b0c63a2a64bfc8e4d304fb2f6dc42b8d43f1cd166fe0568a52"
    sha256 x86_64_linux:   "a0c5646fefb5bbfea29a9865259e2916655cd7c204864a6da97206e474c04776"
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