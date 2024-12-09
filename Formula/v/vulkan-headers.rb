class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.4.303.tar.gz"
  sha256 "fdf0e2e05356b455137ff97f837c9689ba253ec7d20f87ad81575b9bdbe7fdd4"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8259ffd987dff86e25c1aa89f97cf04cfa5a65430cefb222baea2974c4f5a91"
  end

  depends_on "cmake" => :build

  def install
    # Ensure bottles are uniform.
    inreplace "includevulkanvulkan.hpp" do |s|
      s.gsub! "usrlocal", HOMEBREW_PREFIX
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <vulkanvulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system ".test"
  end
end