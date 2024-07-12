class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.289.tar.gz"
  sha256 "6166182b6f279d85784651bf21a134a4016f429cd364bc587ece7b5af9af32d7"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d797d91d131aa98e1ce7916e418f3c5327d00aaa696c0d756752ab85367d201"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd9a2adcdcd42f796c0169a305916111a9d82e905f59605136de8393fee63478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8909a7b01ba2831ccf1cc7cbea750f84ac416eb3972837c8b764e5e07f6aa4e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d938f0f619ba81d625d2388e5e4a873c5c986a724d5852cd29c5bc1bdff27d5b"
    sha256 cellar: :any_skip_relocation, ventura:        "5a34666cb200bac4dfdcc165273354b4c536a307ee2e6980d074e9bb3b6bd132"
    sha256 cellar: :any_skip_relocation, monterey:       "0d01c6f4f64840a5f0cb32154a7dbd972044bbd97e4343a45b30838d9fec1f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d6ef09f26f3c4debdddeed36dc03bf7ecb0e016587974748eb96c0947447ad"
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