class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.304.tar.gz"
  sha256 "daaf71220fffe3988e79f229ae70fb0937e5d932cd176bccb6be0f946dd54c03"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5afb5ff504974af0a0828aa1ed0ccc0174140aa4cdac398ac45e4ee0d19a8bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4a3023ea08794801f4b736dc615c13384c951a79628637621bf521976cfee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a591da683a84240f1fcc04e718622feecf4f702f2e8678e817670a92639d3b07"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8f9766dd48e7e5d5a0f3c9343c19a0e0c646cdcd7dab7f36ca6906fa11736ec"
    sha256 cellar: :any_skip_relocation, ventura:       "1d6858b4241703794b63f426a3c5bf1fdadb2b5b8b1c1d33d930a8cc909b2bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ebdc101d2f033687bd644d7999bcf316718578f4d6a336e31f65fcf6d06f9eb"
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