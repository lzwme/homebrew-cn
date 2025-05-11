class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.315.tar.gz"
  sha256 "c51e3f7faef76b86b74f86ccfc18a7bd93ea42ae9c8acba33b04e7db41ea5b55"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "430a6d084381bc40283d2ed0193edc06339953545970118fd835b50ad8a1c894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2507831b7fade01eff30b6c5adf75276596cd90fe146303fa6eef42e257dec6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fa51bb86d75707fb1148e7b1577b0c1f33d94064cf8d651c47d1255072b402f"
    sha256 cellar: :any_skip_relocation, sequoia:       "22dee361200e0841a441e58d8cb75aaa317d7a7aeae890a305eb1e6ada470268"
    sha256 cellar: :any_skip_relocation, sonoma:        "59acc433977030d86da36a83b21110f5548ff27aaca4aafc0d313d31b1d7f9d6"
    sha256 cellar: :any_skip_relocation, ventura:       "aa5cc824b07ff98470dabcf86b5dabe77fcf6c4bc90c3b60fd82e47b71026eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "382e1027cbfa43cd178653756f5b86b6cb32fe82f26ae85fd5e1b50873a0c284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f816283989e9175523cfc18ef793fb71c3a017231cfd6e2fdc096a892b7b6a18"
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