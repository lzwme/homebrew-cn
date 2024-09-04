class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.295.tar.gz"
  sha256 "9dc5247bfb1585ecab48fdd4708b52ba1839cebf0347077bbc897580401b15ca"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c676320b23f5e62f0a5e5e5e080d20d514098641684c3212ec0c1abd2e692e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2773113a13b0bb5e2255290f01d9c7af899ea63d7f6895e9c57f15b0496f2032"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4fb236da8adf0acbcbdd47d2a4e9cb2a799219d7e1c0bcd8cd7a2d4d49fcbb2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d2212715f1fe0c6d7690e649e019d9b78fb5e883db5fe8a463a1bb9962c17e8"
    sha256 cellar: :any_skip_relocation, ventura:        "40880e567dc04de4e10215d9dc1a82835f05cd19448f57972f951b56c1687ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "78dc0498a2f09d5135bfa57e67bb24f3004030768294c348ce537cce50a15796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c6081368f1508790672c2569be783d614e2001ec38e2c746c0fbf0d8e666ce8"
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