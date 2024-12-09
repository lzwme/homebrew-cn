class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.303.tar.gz"
  sha256 "e9963da555d2888dbd4ac7a292aa61dfd9ace771319efe57ec25024386511093"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bd45627804844d40b2425f26b913575b7864d34e37da7da68784e2838c9fd2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc5d4867293dede2ab254f9c6f13c06955821bef7d85cddaf1a41fa957730cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d1185b9fb532f997029de645e50f38ed42255e8f73ebb6c6e2ad486faa29e08"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6c05da60ba579739584acd4c84b70ba53d5eaafef765949492104f998798b71"
    sha256 cellar: :any_skip_relocation, ventura:       "088aa05c355d576a05773f2767cef631c6a1e71b38a3f2d6aa70628b5116aea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf822b2dd5ea160409dfec51c06a6ccbf807e5d62c7c2acba2fbd9d433e0a2dd"
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