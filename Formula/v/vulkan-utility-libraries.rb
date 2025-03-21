class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.310.tar.gz"
  sha256 "ac3d567b7dca652b2ea20b6bf65b9fee222952875dd809ca407453053bd45910"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74e18b6e05161c6402b0a18cde2d3dd95d088a986e1762b67edecb081f89d251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c593d0d9db5e5d4f1907bbfc1080e7a2ea06326a49e11ffcc0eb7564f66aa0e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cd2ee8d23128a3d717fc153073e387d9052b293da6902903fbbf0910e0a4890"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eb61f64aa8ec0aaa6b959f1fe4c94b9160304688248db49b30a7ed5475aa2f5"
    sha256 cellar: :any_skip_relocation, ventura:       "76a43a38c56e5d39366f6ccde941849f9bb1184614260fdc9a1475f7552873f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "598616f5329217bc67270c8de22add0eb74c2d8259a57f9c7c3a0cfe74143bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64595533173fb128003eda2b5f29445b1b8a47cfb687aa1ccc86d82ffaed1855"
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