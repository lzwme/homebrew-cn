class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.313.tar.gz"
  sha256 "46b21194fb3d59b0209093716133d75a64ba075ffacbb1d6f05204c2de20f954"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4eb3b05c0e787d23046848e0b405168f5fdff79a12b82f6a311b1618552d305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2e33640b94841c8f017028356cd512d8ab91347081e07ca5df74619f52ae652"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d76a6540f07beac031a4c463b5f331bf370c7a6629c3f539a9e4116cff79e3c1"
    sha256 cellar: :any_skip_relocation, sequoia:       "325da02b75f0caa044c252bb3f2c282f90e30cc631c68a0253db8901df7bcb45"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe0d833fc8fad8d1907c42633abda3c6c0a6853641fdd347d5c253944f8ee13"
    sha256 cellar: :any_skip_relocation, ventura:       "6704b0406a9313e988f309e8a083d409d3f07706cfcadd16ef572b75585eefb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981718116c2155cdb54c022f59fc91b552e3869c3eab9793768826a7080f3535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e7507ed2c399ce294732efb9fee3ecb4fb1630f0a0dcad27c5b2e109a35140"
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