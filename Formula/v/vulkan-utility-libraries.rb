class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.274.tar.gz"
  sha256 "ac6012f7b951170914a85c1ac359f20f276db1cced269b4199a75f7e2ce837c5"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d393dc3167b40c2ee038640c07b98302114bbb28db48aa05d15defcfce9ecc7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2445a33448a98e9301a2784ca002776420348728788c20dc386d284b4329cf0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076dc5918224a53fd15fb53b623a3ff87a932420897d575b670febc13bca3f83"
    sha256 cellar: :any_skip_relocation, sonoma:         "89117c883bebfdb099fb4f81daa7283a23b85734b0f2b53237d8f0d5ab8e2175"
    sha256 cellar: :any_skip_relocation, ventura:        "f16faf28d1a39d630265ed5e18eace09c73d883145dec569981ff916a5a19375"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b8888fbf72e255227ed1bc6e22b5fcfc5c4182504ed9939fc61838a223651b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "985ad2154faf7c473f423f66888a2ae1d9bdbdefa4c7a23e2eac3677039f7ef9"
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