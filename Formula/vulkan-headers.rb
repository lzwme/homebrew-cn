class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.248.tar.gz"
  sha256 "e2a3ef209deee3e47e67f3e57846f343c53b96fbe854f5c7427f0bfee478907f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43b0a0b9c75ad6a9bae19cc90d6652e28e99cd89e514acca7f1e22e0ab2854d3"
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