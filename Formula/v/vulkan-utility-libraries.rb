class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https://github.com/KhronosGroup/Vulkan-Utility-Libraries"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Utility-Libraries/archive/refs/tags/v1.4.326.tar.gz"
  sha256 "74bc0be35045bc4f3e7dd2b52fbf8141cda7329ab9d4f14c988442bd74f201c8"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d7aeffadc6742b4c6ebc9ee885dc01bdb782a71a4174a7cc676bf5ceb9f5898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee979f1e6f5e0392a1b00060950851deeeee9df1bc7c5a17499b291986e331d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6fec58e2c8d29866ea0d68b9744f3d7602526700aff09d20713b31929e8e86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b314de9c02208b43a7ce118f61942ff88e2f406f4a11e45781a069bb9a312a2"
    sha256 cellar: :any_skip_relocation, tahoe:         "aed0203c02a828719e57032808d0508322e1c943531dee7d8224b83675185c2b"
    sha256 cellar: :any_skip_relocation, sequoia:       "90bc25ec56389359dfb4c23c7e7b133ac9930e0ca1c0203dd832ac415b046697"
    sha256 cellar: :any_skip_relocation, sonoma:        "d06011c1c9f4f54792c38f58d78c59a5b776edf778082f6c32612c171eda985b"
    sha256 cellar: :any_skip_relocation, ventura:       "439b2f225c7f8d8cc75749cff606b943bde3ae21206137fda50104f2bd8c5d3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd1599f48a1b0f070fb3f9ad2772b4c5718cb5e6de46f847191dccae8d66c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2464d0b44e1038931d9aa8d76e51fe6acf26e061b762e08cb6252a30b1b1e22"
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