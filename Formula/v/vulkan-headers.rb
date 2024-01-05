class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.3.274.tar.gz"
  sha256 "3458dd9049d561d0863069b1dd752cd4a04ca31fc090a58124691d61bff5b62a"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca9dd030127be297301ded7cdf814b9039a7d48f56055de11e04ca745965c736"
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