class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.263.tar.gz"
  sha256 "3390d8f203f764538962d98dc3bdc097f9dfa26458549314f6ad4a210272cdc7"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfb280e0e972c62be9c95826bbd139112701516d60b15ea7d68a9eb8c0ec8c7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb3b32a60d19ea6b4c33f58efa54cfcdd9dbef1ad129875f5d0e2948e3d19fcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc5c7610865476873768ba7f88a5a430513cb23472cb319d68ea2e78323eb114"
    sha256 cellar: :any_skip_relocation, ventura:        "136a885b901a016eda03c04c3d3ecda6d2bb525e80354c9f41dfb1ed74a1823b"
    sha256 cellar: :any_skip_relocation, monterey:       "af41d6036fcab4537f89c067bae430607741bff71613c51cf59bc542de4e4e17"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb1bccd0b2f6098e28a23e95cf337278907614c1ac21936f1e49813374fb39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e31cddb833dbed2bed0957785f2ffd267aa51a0293a25bff7019c68857d916"
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