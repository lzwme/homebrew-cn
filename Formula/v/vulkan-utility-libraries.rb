class VulkanUtilityLibraries < Formula
  desc "Utility Libraries for Vulkan"
  homepage "https:github.comKhronosGroupVulkan-Utility-Libraries"
  url "https:github.comKhronosGroupVulkan-Utility-Librariesarchiverefstagsv1.3.296.tar.gz"
  sha256 "bea13c5f25756a9b20bc53cfbfb1a87b4a8e07ddfb7ebcdf9e173c4461d55685"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Utility-Libraries.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eed7ffea355972acc4e220d8d620513bbd76004c5523d2c7662b9764a67d25b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ddfea68d18493d89e85d891464d9aa64fbe5d16da22e65c2b304b71037e8043"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e44a4805e25b3bcdbfac819d04287958fd64513f0155a87db505f524d1d9b5fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b601c6ef89d29085990f038d8f5d7a51c12d073711080c4d272e595fb5f7db2"
    sha256 cellar: :any_skip_relocation, ventura:       "d12c4f4b3ff048216f627745ee7d04b05870da8702fa15a07e7924f403cb8292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24c50d8339716e3c3f7b3abdac8d5a915d49c6738d63f3bd282bdb85e7802f3"
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