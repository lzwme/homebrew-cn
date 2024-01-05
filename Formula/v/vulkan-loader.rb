class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https:github.comKhronosGroupVulkan-Loader"
  url "https:github.comKhronosGroupVulkan-Loaderarchiverefstagsv1.3.274.tar.gz"
  sha256 "8abdcc24fc320f811c24a6faab8bebc932c32d3024526d08e75e60cc36d0a811"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "f14affcd41cfbc15146f7f478c4badff6194b9bfdd1e3811326e659946cb354b"
    sha256 arm64_ventura:  "0057480cabe1da4d92cd4054a06abe4e51e2312b2d60b4f5a7f975567c1ffc62"
    sha256 arm64_monterey: "dde76557cf06f23d8140f85379ff18862910174e2d07a102ebe0dda88186c2a7"
    sha256 sonoma:         "5454bf1983e3b6294b13c87fbda25eb1efa84513320a0b970b7feb1623bcc934"
    sha256 ventura:        "ff6702d6169de2b193d93fa4744a10ded77a98f6edc0890520fe7947b1e97f7a"
    sha256 monterey:       "f055698ea7fe105cef77a17b6d687638a5292a8902ddff37da852e87613bd192"
    sha256 x86_64_linux:   "f8cf9a6446e2e0e37bf5294b783a3062c967e2da25805f686ecef6352956fda7"
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