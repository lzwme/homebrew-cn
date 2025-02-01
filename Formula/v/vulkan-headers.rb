class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.4.307.tar.gz"
  sha256 "6e8445bc12c1e2702c27f4f02d1a057fb83f40cc56c6a8e4583141d4eaad90d4"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f1dc61764f763c7009a68a7190d9f431b4a1d16367d5214db96d0d64e4eec2e"
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