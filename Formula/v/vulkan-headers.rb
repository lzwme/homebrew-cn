class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.4.316.tar.gz"
  sha256 "895caae5a68ef6bbec291c7df953a463c751bee1b6e628b612cfbc2ef83ee3a5"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a9c28371944d675f5184f7499661547db18bf7fd6393ba367f8573014e9be28"
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