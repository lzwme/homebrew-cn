class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.265.tar.gz"
  sha256 "135fb8ecb8c3233bf6e77c55b9d1c485a1afa50034228a543aac53182da98494"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11b04820c4393ecd87c72f3194c9ab5eeaa278f463861021c83f904070087ee5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06f501f77f2676635a7abfd00f288537fba0f99dabaeb5d0ea8ba1acee9ee6d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5956bec2d7fec922f1127f8a76498a3ce7fa4fc159ecba3141413c624bf6711a"
    sha256 cellar: :any_skip_relocation, sonoma:         "59c8902df243bbcf90c253d5fa913e82425a25ec5b2431acfc3251fe5aa96148"
    sha256 cellar: :any_skip_relocation, ventura:        "379fdfffdec90667a62db4e1198b1263eaa450a241b5e93344b1f1c7dcd13c90"
    sha256 cellar: :any_skip_relocation, monterey:       "bc0c58fd6fb46da458cf3ed6a2b62493508d42470e619043f04c9829e40da20e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8372474fc002a2091c553bdaaa889c9adb62e3a44ef5dd973cd2269dbf37ab7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/layer/vk_layer_settings.h>
      int main() {
        VkLayerSettingEXT s;
        s.pLayerName = "VK_LAYER_LUNARG_test";
        s.pSettingName = "test_setting";
        s.type = VK_LAYER_SETTING_TYPE_INT32_EXT;
        s.count = 1;

        printf("%s\\n", s.pLayerName);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-o", "test"
    system "./test"
  end
end