class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.259.tar.gz"
  sha256 "da9e625935014e8aa1c31c4ab45d7b015d73185586b1bdf70c646d66cbddc3d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, ventura:        "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, monterey:       "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d230a2dc71f02514d30c3ee2cf032ab90f0c25c3188951fbb520f9fb9b3682"
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