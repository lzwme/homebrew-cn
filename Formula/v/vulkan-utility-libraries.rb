class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.325.tar.gz"
  sha256 "00077ecdc8ca82871784b0ec6efddf493dc8e27099ed5d21643a6677eabdcd93"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b176dacf574d4e1d71d7f16f897b5c62c54377d5a35ddfded8cc70071721460e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7992736fa2e3040e940f7dd59042c0c7b2435f635e917c360cf9b38af8e3da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e029c4d12c955d16e6f40446044ff195ebdf0b1f5342bdbebbae28f3f596052"
    sha256 cellar: :any_skip_relocation, sequoia:       "3bdac7a4abffc26865cd8ade7cd0e47c1ecf0d1d7fb261c17df75eb651b178ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c95c6fa18fc8c91cc3ea1d8224e9b280dac69fd5d579965e8b38f02e6c112e54"
    sha256 cellar: :any_skip_relocation, ventura:       "14d79e5cc0eda671567af37902e38ddbda9ce49f9658fae7a78304a6fce81d40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df07eb3f34fe461152c39afc3fe4d4156c5446180bddfff7b4725c3be3fa9728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c87f9d7c596c5144f0eefec89dce9fe7362e67d6b1c0dd117d67295f0a0653"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <vulkan/layer/vk_layer_settings.h>
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
    system "./test"
  end
end