class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.294.tar.gz"
  sha256 "9b008530f9ddf9ce05e0fb7adaf8ebb7517a5816c969ace592b3756fdaa8ec97"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "133d4fdcfd4acdfe3cb9076e98cc18dba6e3129c46f0a808fb10e5dd3198bf31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fee32e5b7796ca28cbec7328c830a9fc382a5c52f746a51d71afd7d6ddd8162c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3f88af3d39b6990d79864b0823d0a82a0f61c9c4753635583bc1c4d934d76ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "698599a1a1df98bbbea4a90ae079ac1410120d79ec65c28aa122978d4a940394"
    sha256 cellar: :any_skip_relocation, ventura:        "d9ae3488c0f1e89d7a35419770e18fb182edf365451434451f016219768c36ba"
    sha256 cellar: :any_skip_relocation, monterey:       "a9dfd9bae64b7eb43bf2dce3f34f2f3c35e1ba01d46dfd077041efcf31925c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fed43e041c2d1ec5e7a3b87d7f6b668b8015cb12a628d828bd6975257b5c521"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-headers"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-o", "test"
    system ".test"
  end
end