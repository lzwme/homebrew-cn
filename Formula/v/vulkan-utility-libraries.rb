class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.301.tar.gz"
  sha256 "9e5e7ff4bfc8aae6f9a5c51dfd136668b249fccd64d9faefb6598573641509bb"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d4b12f3234d9c27fe5b113aa498960ec3fcd9156301bda9f37dbb3b21d38a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a251dfd7232f8b6775b62b1f2baf0e2b29b5fa9dd9f2378e9fc88229f89493b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a04777fff59eca36f25bdc6035ddaab54960cfdfb398ec0b4ae7979fc687e8d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0a5454288012f123bfbde395e6eca91e9b58be6dd67eb4792ce38c3275a6c21"
    sha256 cellar: :any_skip_relocation, ventura:       "0944fb70e0c011fc91b223013b4741c29547c581f8acb6fc80ba0a9ad6b0dfbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ed3016c47eae39bc3bd8ddc1e321a64d09bd1427097722a1e2ead43ea923d3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-headers"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <vulkanlayervk_layer_settings.h>
      int main() {
        VkLayerSettingEXT s;
        s.pLayerName = "VK_LAYER_LUNARG_test";
        s.pSettingName = "test_setting";
        s.type = VK_LAYER_SETTING_TYPE_INT32_EXT;
        s.valueCount = 1;
        int vals[1] = {5};
        s.pValues = &vals;

        printf("%s\\n", s.pLayerName);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-o", "test"
    system ".test"
  end
end