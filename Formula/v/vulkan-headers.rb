class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.3.268.tar.gz"
  sha256 "d5c59d5fc3ab264006dfea1eb1a11f609ea5dfa8319a5aaca061007828012a78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51b2eb50e15e5f418080e6c180875667b3ff20226ce8c4ef0c1d1a8659615582"
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