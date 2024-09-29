class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.3.296.tar.gz"
  sha256 "e204e0b3c19f622d197df945737f5db913d6621830999b8578d34e80a7c90585"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba8cc80420ab51ff97a5a78a2b1e9c2fa610bf5f9b757fcd21a018fba7e1bb09"
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