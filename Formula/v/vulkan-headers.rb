class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v1.4.325.tar.gz"
  sha256 "5743da4e203456ef0a0d17950d448b4f70e93a19abdc547aa33c15482b4fec17"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "884063314a643b8ce44cc4eb5bf93155ef6c0f41f9bfd04eb5a0f9828a3daa09"
  end

  depends_on "cmake" => :build

  def install
    # Ensure bottles are uniform.
    inreplace "include/vulkan/vulkan.hpp" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end