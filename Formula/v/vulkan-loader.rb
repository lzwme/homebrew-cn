class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.4.313.tar.gz"
  sha256 "0c2436993597f5bd0ee420b6b27632758ed3ab439043d251795fd13d4e70a2f3"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "11bf3a933d370c2a373bdd7dd4353ec9da958c5be255f246650f7f5490cc688b"
    sha256 arm64_sonoma:  "c6defd5153ed9940c5bf889ad54e8d779a50cd6f42b8488b8bfbfe33286712f5"
    sha256 arm64_ventura: "d5dc37d887f0d04cd4b292d299a455b82394ae3171d58fcd64e16c3b190a18ed"
    sha256 sequoia:       "7509536f6c23b062417a28dc083faa35367eca3fe9084e5bf34e30f415534f08"
    sha256 sonoma:        "68f4d4fd1fcd7e53df772bfe76f5e163c282aa72eb6e571307bc11630cd3be38"
    sha256 ventura:       "f1bd22baf3a350e5d8357cb4a6ec89d453b327a0dbff4bc5e60fbe9e9444a405"
    sha256 arm64_linux:   "001deba64784e5ed9d8ca83d5740b29e52bb2d4074f0d668a85b17e6d069a5d6"
    sha256 x86_64_linux:  "183a67c0cf213853406d7d694917c2e7585eedf4b58a707a529444ce82359412"
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