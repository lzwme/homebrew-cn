class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.254.tar.gz"
  sha256 "6be000a33b665ecac05971819b4c29ba5e21b800627f288f4d3a0b28e86b290f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "349cba0b18a24db35336131e5ac62bd9bd3d59456a80731245e8c5e80bfa4eb8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end