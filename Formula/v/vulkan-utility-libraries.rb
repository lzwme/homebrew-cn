class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.275.tar.gz"
  sha256 "96d3ec7bda7b6e9fabbb471c570104a7b1cb56928d097dd0441c96129468b888"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2dab86afe8af72d3da703b03cd892f14b76ee2051a4a2c9feff4291c2f3f19a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79058eb3c97f36140a3fe3f2f6887b1fab782ce3e6e590e8531ac499735abd60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "232fe3c8b5253f37be4c61b261d327fd1174070dcba586c55e4f8472bc3fcfea"
    sha256 cellar: :any_skip_relocation, sonoma:         "65ecfd575f92f559f5abddc2bcd8bd5abcbbc91fc0b7470967a277d5f591dc6a"
    sha256 cellar: :any_skip_relocation, ventura:        "906b5e76d9f416d285fa09ab729fbc44694d9f4b0b7780f18dc05cf68551310f"
    sha256 cellar: :any_skip_relocation, monterey:       "c5b9e89dbf11643df069eb63b9c92708138c8fd5cff63debdb9c55bef2269ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9509900cab2f04c00e4d66451f16ff0434811025f23741b12e27de184677907"
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