class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.300.tar.gz"
  sha256 "ffc35127708e1fa94f97ed356b645c4a93e1dfbf8e9d39e48a1d27685a3899fb"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "257eb85c3ffe858a05c3729bf0d7d0d45e672ac3f3c8f659b21e23a63f114602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49127ba60e85d72185fc6b7ba5129b16c326a163d89774a042854dd6c09d05cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "110d794d108227ca9dc06c5029c51c2750c0c300739bd755c694ed80cbf6e5e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd31de00f37617ff3ebd774decd05e2011478f10646e4ae9714beb6132a2f4a0"
    sha256 cellar: :any_skip_relocation, ventura:       "c8dc0fedcabf49106df8a0f31c31d32c6d03be4fa08e6dd2d62612d36fc87075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50da16cf1314f271015fddb7a83c4bc4f853bc2f221dcd411e31b74edefff39"
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