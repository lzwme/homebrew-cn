class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.3.276.tar.gz"
  sha256 "91d4695fd99cc4431740e25199f540cdee23483900243e0f395e0807868589c6"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af92d0f4645df5e3476344be29274be6339f5201bbab989bc9f41c81bf63d600"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkanvulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system ".test"
  end
end