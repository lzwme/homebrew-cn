class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.319.tar.gz"
  sha256 "904a91a8cafbf49db9b020e48be486a73ac6370c6b826495341dd8fc2b7ecca4"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0749f565deb9eeeda09769b9acdb79ab66116700133041080732f8b2e0efb12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5946e132132ba9171b9692f7ba2649d36b5dd55f4c4f348d8534cd97e180e948"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8574469cf483f1de82995e6fde9a1e7488d9e337e6dcf6dbd4f8a5f3f741d3c"
    sha256 cellar: :any_skip_relocation, sequoia:       "6b7a91bd65d974a7a0682909fc84ef687b985992a0a8d63130c8084d6bb7a43d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5452761078c04f1dee1e4b078484d0004ae027b6825a094bad99987cda9f242c"
    sha256 cellar: :any_skip_relocation, ventura:       "59bf93cd29bdc96974e0f1cbe0809e450c51281c444cda482d978cc32d1cbbd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2b034c856eb4cb5d0dde913426ac635c53e10c0d2fc663fbe60e061ac68d2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45eb5f208bd06fc630f18528ac0d63a07d431e6632967888ce918577caea9d1e"
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