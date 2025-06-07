class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.4.317.tar.gz"
  sha256 "b2ebc07892bfbde4e15288b73d5406dd0bed83a889775b4738aa06daac90d02d"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb9204c9e1484d3f78b9e9e493362e2d5c8ba8e2ed4cd50044ce8c71396aa0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fd5628d239aaf4939aa9ce0a040c996468f36bdee759ea715c3a2a13ba768a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86444ddb6d569aec65930a67cea72b895ed01a49efd8e6513d7e0afa3806c65c"
    sha256 cellar: :any_skip_relocation, sequoia:       "b56f1b40292db5867d51014a20d988348ecfebc7db4dcf1059b5777557800d19"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b7c419d867911f0cd0e6a6aa644779d505a6833245adbc9bc790f30c696461"
    sha256 cellar: :any_skip_relocation, ventura:       "1228e7342bb8b508fafc76f7042cd8e97bfb6517d174f03e2e7821064488ce1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dcb6b74724edc96bc6ab7c33c61efe92f8093b1604a2aa802cddb0c2719fe33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0d6b9902d77c8f8bef06149b7f6084896bda17bf276bc90dc8dfaa707928af"
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