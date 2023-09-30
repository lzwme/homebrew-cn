class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.266.tar.gz"
  sha256 "0b3451c3dbda492be010738fb90e5cf80aa32f66705cadd9a12c573e0e351fd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29a35483e2b759f20fbc5469b20a74aaea56fedc4a0b88de57af026b2f95f4bd"
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