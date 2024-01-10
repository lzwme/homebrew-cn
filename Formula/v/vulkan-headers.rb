class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.3.275.tar.gz"
  sha256 "7161da645dbd33fd4ea61eec08e0d77389a640010acbf4afc00234f84df9b314"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5843a0eb75b6c42637bab99bccc302ebab4d474a472789af4a3fce0208812823"
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