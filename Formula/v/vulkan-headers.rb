class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https:github.comKhronosGroupVulkan-Headers"
  url "https:github.comKhronosGroupVulkan-Headersarchiverefstagsv1.4.311.tar.gz"
  sha256 "7989c360b870bcc2de52b9fd626fd2ba7a212fe177ade3aa3a10b2bcb61f8689"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9abdf7788f1cbed5ca5f1d9ea9648d4ca4f74769b5f485464d326a015c863c13"
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