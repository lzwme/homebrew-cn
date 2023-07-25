class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.259.tar.gz"
  sha256 "7f12ddf2c6d4a26c354844bbad3ab7037b647aab5540fe87c8c34663d0d3b1f8"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "399f1f17775c2dc2689c7e0f0474d66ba0d3c479d240567cc9ea7d01ef002d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7b181fa183f6c09d9521e918d0257425d3c2b0bcbc2aabec029f332125edfbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64b2c6cc14332957bbd4896c5f6692269f32c3d0fe745623183f53872f6bad07"
    sha256 cellar: :any_skip_relocation, ventura:        "4f5afedaccbc7d1c3ee4bfb4296fa5f4ba1467e81b1cf16562e1d507e998149b"
    sha256 cellar: :any_skip_relocation, monterey:       "57bedfae6f7b6f2de2767911ba5bcd4d39192ecefa7f099919a215456691d126"
    sha256 cellar: :any_skip_relocation, big_sur:        "a272a2e86f66352355d6dbd6039a51e32cbd1abcea5abafc515e30479071b6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cdd7dfed82d0153c81c4af02e4067e3c0342d531d61f6996b58b9afa13fbd98"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-headers"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
                    "-DSPIRV_HEADERS_INSTALL_DIR=#{Formula["spirv-headers"].prefix}",
                    "-DSPIRV_TOOLS_INSTALL_DIR=#{Formula["spirv-tools"].prefix}",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use these layers in a Vulkan application, you may need to place them in the environment with
        export VK_LAYER_PATH=#{opt_share}/vulkan/explicit_layer.d
    EOS
  end

  test do
    ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"
    ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib/"mock_icd/VkICD_mock_icd.json"

    expected = <<~EOS
      Instance Layers: count = 3
      --------------------------
      VK_LAYER_KHRONOS_shader_object      Shader object layer              \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_synchronization2   Khronos Synchronization2 layer   \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_timeline_semaphore Khronos timeline Semaphore layer \\d\\.\\d\\.\\d+  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match Regexp.new(expected), actual
  end
end