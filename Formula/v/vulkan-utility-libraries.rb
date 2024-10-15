class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.298.tar.gz"
  sha256 "c0c49289bf8265beb5ded06826be742f3af2726d394595cbc56044149bcf5798"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd1ee82d8d7d8ca7706b219cb8675b428fb113e38ed5e75fbe6b49254577040a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ec8aa97b27d8a6183f37eb5e0d5cdfb201d690d594d41929a4495b1dada50e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9598f126c1171a0aee5cec528a32d55319897de4b36ed330bf8250a0b3b9b752"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bac914154bdad5afb5b0935458ada6c68507f85040d8f3cadc36ac1ae1876f2"
    sha256 cellar: :any_skip_relocation, ventura:       "b61596d3da1a65046aa9933fbfddb9d1ba0b2aff547d2b2fcaea48e367d48587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41504bbd4f9b1ae7fd2e35980e197157889f6ab6d61f0ffc46c9e315a2de4247"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build
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