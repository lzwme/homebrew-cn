class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.309.tar.gz"
  sha256 "d888151924c2ec0a0a852d2c7d6c2262362f535513efc2a3a413cc2071b551d8"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d3bd4807d8087d47fdff3152a3ccf9a4a2506234b9ea93b772e86ce6c1331cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12aafea4e064f0a5456c7ca9bc25b57ff977b115248ff060adeb9581d98472ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baf09d864ddc1b6b697080a5aa384194ad2653ffd77ca53fffe4231defa11650"
    sha256 cellar: :any_skip_relocation, sonoma:        "44bbe2d889490c87e0f34f7a5f96cd2fe3dfeade7c471284353b4eaedaadde53"
    sha256 cellar: :any_skip_relocation, ventura:       "fcb44e564105ab8019309ab0c544091de583ad9efae22f4edb6d9221c6088501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091f39090d39d970a8c13d49c152ac7c542ee0b030e35530a18674e72d173aff"
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