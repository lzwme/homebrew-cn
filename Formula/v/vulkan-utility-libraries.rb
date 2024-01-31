class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.276.tar.gz"
  sha256 "1d1cfb14b5b0db94245dbff6a4f7fa374f749727f6d357c3501e5dfa8e5dca80"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "283aa8a03507eaae9c3a8f247f04ee5eb0aa97e8488bec02cdbdff3517d68a95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bc63b8acd22ec097a691fcc1f409e63cf9e871297182f09262f3a49d5bdcd1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c4235439896ec329196375648218c0b418f4f1f2f519199ce599d433b4f9ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2709193fb6ef2d37ad30f0c731666e1243fd9168460874fd72f981d128086e6"
    sha256 cellar: :any_skip_relocation, ventura:        "63668a14013c94efe58126ee2d92d1d794cb72250b11f06cfec48a0b08ecc39f"
    sha256 cellar: :any_skip_relocation, monterey:       "7a740776977448befa00b52b417d8618ea03e1e59df42902ddf74227f6a4cfb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c69252b5dd8ae34e148ee36975248b5c7477e3bd4e0c485e750b5d275b78785d"
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