class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.250.tar.gz"
  sha256 "c4c5a706a1f8f4d329fec2909b8c3fef4a4be043f393dbde5ce1439daa1194ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5382fd2b86ffee43a17f5c728865539f14e40fe847445fe7178ed78ed827de53"
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