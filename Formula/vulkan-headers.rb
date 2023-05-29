class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.251.tar.gz"
  sha256 "e14ac3a6868d9cffcd76e8e92eb0373eb675ab5725672af35b4ba664348e8261"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8df4828dc0a218b5f5b56b9eaa7c80266bcfbd4d75727eaf47ce6f0f6c6a040e"
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