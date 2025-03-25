class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.311.tar.gz"
  sha256 "c30846f3bd7c4d94c57d8c8d3ef307d6183bc59846c9da6240590a4497ebae0a"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1629d644207c1c15c342251db19376654657132c19be7e1da7122710d5f5a5c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6315fc1536169f3f0d8460387ca14a021d66dda01ef3eeede8a1367efed3baca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83e5b06dd8c7605891588d147fe1ce24631ab2178301e47c9bf4fbfa65a619d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8d56f6560e5018a17b52a2fc4d1550cf6993940aceb6bc150801c76bbe847f4"
    sha256 cellar: :any_skip_relocation, ventura:       "12c451fa33ef0f6cea9cc0ca08acbd8fcac743b9aa3180a96e093370f9e67f7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "032f804b6825ea480ec94ccd0d1b2d7a9d94ad7bdcd9e8e81d379d9135caf7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa5af69998e463bcb64eb332ed8af5c9fe3d5ddf5720472cf9cf471b7ee10bd"
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