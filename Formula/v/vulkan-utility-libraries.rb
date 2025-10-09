class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/vulkan-sdk-1.4.328.0.tar.gz"
  sha256 "8cc984ff62800be5e56b765536f533bd32444a6ce5901185bf1b2a84b85f618d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e909ab11bd6d4f7843dd7d68de6c907cb7fd007608292eff68fb12a40e4f88c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a63a8df5b671aec902ce279a4d80660580eb943e28fcbe26d2b29ffd11b45a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b5f5573d5815a044b3a2012b3947002b034fb8eada547eaa1b30c4c0d45805"
    sha256 cellar: :any_skip_relocation, tahoe:         "582a853813e356f2c0746e27705411703b9f96c3d70c626a458b4829f8e6e121"
    sha256 cellar: :any_skip_relocation, sequoia:       "e36459540c0273ccab26a3b1005d161118b9fb25bc6f3cce2741644b1bfd7170"
    sha256 cellar: :any_skip_relocation, sonoma:        "be5ec96b2fbc6b642e69c18e0695ba40d477464d96578d2cae1b0f2c5cb3e1d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e668fe9f32b3ce3433e5d74041fdbd135b062e7e1830a8ca7287f5561ce2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0801aaf77d9461d08f815d4d0032cf3fcc88de25fd3d46912dd2b7ea31430cb"
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