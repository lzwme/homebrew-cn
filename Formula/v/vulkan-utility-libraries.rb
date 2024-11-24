class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.302.tar.gz"
  sha256 "d9e0903e3a2916e2be8ca49f7ee750a1364e33fa021f5bbc02e032c4d54a8bbd"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09125f32829d0c2440273bb02318153b8e2bdd75f603587b71a9980c2cbb9838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c7aac52520499925430f5a0335e53252cb23ef04af1effed02f857577c1404"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4dbf82929e47cd88fe0364b324d0a5202b0d80157f4a4b819b049d407070d1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "73903462f63ada14136d43c3daef12e966cfd9fecfe590402c5bbc310fd38474"
    sha256 cellar: :any_skip_relocation, ventura:       "2f2510d9b8e0405c75c8dd11a8780d9d5dfb5721307b8c3a36b146aa1a71d174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549c5ca312c47ee814bcd5ddaabda280635774766b93cb2749d0ee23e0b132b1"
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