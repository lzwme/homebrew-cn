class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.290.tar.gz"
  sha256 "daa5106b3c3a9f84deaf179c7eefb8d38bffb4839ec06bdcd00071f89ec8b613"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "275183a2620afb52f6f4e07fe91a55e83d7874b2994d1a6baabeec4721616af3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eca1dbf0e5db19e34499542045f8640bc9bf78b593ead3e3b465db8565482303"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edb35671984423178584c43ebdc692f6732e7cc02b146a709539696ceaedf903"
    sha256 cellar: :any_skip_relocation, sonoma:         "0baf6a2bbcc710d072cc6457f7f1193730a0e52e4884e5445bdaa44050e5ed58"
    sha256 cellar: :any_skip_relocation, ventura:        "2e7df5a82fb30927d4cf7224b321923a48e049333e681095ab97973a13b59bcd"
    sha256 cellar: :any_skip_relocation, monterey:       "c524d5bcefed8a04f37a98f0420b404534be61085bd9c68f58a2319fee06792d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd8fa0a2f927a2170d126842d49f20325eccae2c406c6ea8026b37915f6e4106"
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