class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.260.tar.gz"
  sha256 "b0553a848c4db3197a2a664e833fb7ac7241389a7c3ee1f76d5198fa0ce8a690"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1c530a3d7765d6e32679530954da2e6aa78187ca5335ff62d6db5cb5c7456ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b4bc40d2a86b00326ecac7a01fa426d003095de818fb41adbba94a14c2f5f39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7241d36867c91bc02182d6d62401848d3071922f67d1e18dd0cc121653dba607"
    sha256 cellar: :any_skip_relocation, ventura:        "fe6b77be7d8d62f37c963ac0f7e2f9ce7fa3da054928c7b42b76f9070390cb14"
    sha256 cellar: :any_skip_relocation, monterey:       "8a76afbf8cb5954cbda2b547ab1cd001006d44f08dc92d0821f49667ce682f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "86ba09daf4f2f213d802d0d7bcd78ca080353815ab11cc44fc9bd35b7f044506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cafe3442c0c265c75a4efa4eb1cd740c8ef90a33588c621e531314c7890c709"
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