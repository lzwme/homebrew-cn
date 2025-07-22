class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.323.tar.gz"
  sha256 "33d7751eedc9f6f626fe74336bdbabb6e466af5e98e64862085e03c3df676082"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e96bbcc0bfdcf488c1b8a7b3e2b41b5866d3271c56c809ad0a07af07bf3e3fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda7f7491493d5cbfda5215e9a3813877e7c1f309c401165edde83c11770030c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2b28b88fb2921e037f5d59d85b70489367a22dfbdd79d0c5edabe05ec434477"
    sha256 cellar: :any_skip_relocation, sequoia:       "bca6cb4102920fc4c0daf49570533e6a60459d9d700269df0c89a79e7a436db6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fedfdf58545c1655b7f6e37272d2c5833b5c6b37092b8b4c432afcb50e44ae1"
    sha256 cellar: :any_skip_relocation, ventura:       "523baf0c9915e974cd3d9dd1dbf17246646f8e21fc5319ab7f73903b61aa2362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "540ed7f9754bd66aed4d25f9185a086f89fb5e948787dc74e377b77aab69e019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373c865da25efe1fb4560bccdfab65b1180351f946d6129af791e0882e54c1a7"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <vulkan/layer/vk_layer_settings.h>
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
    system "./test"
  end
end