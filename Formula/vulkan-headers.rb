class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.258.tar.gz"
  sha256 "00a1f1859bd1ee8337f75d3c94c8f2d0065b9681f29d7255abaaadfe0c9bb349"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d0bb937f338d8159cb262f1dfc104ccababebc68b67439d50d1f84000b3ff36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d0bb937f338d8159cb262f1dfc104ccababebc68b67439d50d1f84000b3ff36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d0bb937f338d8159cb262f1dfc104ccababebc68b67439d50d1f84000b3ff36"
    sha256 cellar: :any_skip_relocation, ventura:        "3d0bb937f338d8159cb262f1dfc104ccababebc68b67439d50d1f84000b3ff36"
    sha256 cellar: :any_skip_relocation, monterey:       "3d0bb937f338d8159cb262f1dfc104ccababebc68b67439d50d1f84000b3ff36"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d0bb937f338d8159cb262f1dfc104ccababebc68b67439d50d1f84000b3ff36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a97b5494663951c2c59a048205adda96465ec91bfb5dd809ddd46a6447ee43a"
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