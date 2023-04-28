class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.249.tar.gz"
  sha256 "3d957cc9d07c22b35226c931ac9253321d3b56a769794081a970ccce6b1bbed7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfefba72214080d28e585fe40c9c59706bf8ae44cab6d6cf1e6916977ea4c61b"
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