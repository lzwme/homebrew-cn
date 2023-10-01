class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.3.266.tar.gz"
  sha256 "f4c3906b3fc64de328484cca6580dd12f384a60f1f62111eda5ac4de7a6cba4a"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62baf340e5ab7d6d8497215909f69f7bc1c7cb4fa80eecb74f11e54a024ee3a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dad34f2be3ee8b2ac2d20ff6d1ba49fb799195ef2d4b4c9f7c002968e7f82fc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d64c15f2e3fcbc07ce2de3f42533d1e79c4c395a834223bb8e62d9a346765b"
    sha256 cellar: :any_skip_relocation, sonoma:         "04d2f392bf1ed0515364a6f388e96a96089b0cc790fd60a32a131dea7d0cafd4"
    sha256 cellar: :any_skip_relocation, ventura:        "c47335d85eca869b3e0b467ee594aeaf354e679c5d9335c2408c8146868a7753"
    sha256 cellar: :any_skip_relocation, monterey:       "6b0243796e60c1fe7366d943fc4e93521226fb752e21daf209924aab4ef2a20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b425ff6b5e32b1f151eae3b9109fcddcb2bde57a25c6b735e7741c80dd2d1f38"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/layer/vk_layer_settings.h>
      int main() {
        VkLayerSettingEXT s;
        s.pLayerName = "VK_LAYER_LUNARG_test";
        s.pSettingName = "test_setting";
        s.type = VK_LAYER_SETTING_TYPE_INT32_EXT;
        s.count = 1;

        printf("%s\\n", s.pLayerName);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-o", "test"
    system "./test"
  end
end