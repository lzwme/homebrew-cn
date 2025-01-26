class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.306.tar.gz"
  sha256 "8e60c2a92677d18a5f2417479b3ae0df65c66ab1d52e8918de175460a4c86a8a"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76ef7c2e00cf2671331b298e2ebbcca7507312c89ab368f2f3ae90bc1691fa08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "079718665efad459be6ec4e9b90d950930b1a9008392ad6d17d2e89e2b15f7ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f89ed488d40926589ac7ec1d25aabb8e307fe85228b1498a929c1c0a440599c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1727275ed1f31e1a89db7e166a9d0355578f592015b632863706d17779fe85a1"
    sha256 cellar: :any_skip_relocation, ventura:       "98d270dc6ce0158cd37d9dd9bb8168a55d9ae896ddb653d8c007b5ba0e6ead71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34fb0ae6dd1e76b2143f2b4a8adb562244af85b44948fecddb335596f050529b"
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