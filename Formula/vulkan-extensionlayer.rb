class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.256.tar.gz"
  sha256 "14c96f4591b20f9143e86ec3a2c10e0d1986f036e547f49b9054c65d83ed24ec"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc6caf5a4fb27ee17211d7dc4c7ae2d00c8eaa66ca26a9c5cc17bd7733646240"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55c1612622e30ccf36e8dc040346e2415054098b2eea258272059124adbc949f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f0f0e40d13e792a2aaaea6a349f14bad089eb2b9af201b5ca269ef3fc866c88"
    sha256 cellar: :any_skip_relocation, ventura:        "54602dff65bd9bf031ac4b1327b59485a5d6f663fa4748ebf84724a90f0f96d2"
    sha256 cellar: :any_skip_relocation, monterey:       "190f6c5e60254d89bf3b0634e7829c4c95b6eb7ded34f48ecedd67cd538df856"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d8223a45daa74239bb53d3a2308e3cad9d4463c571e49b48fe2616ddb9300ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3908b0c74a51bc560d8f12a4058ca0f3a336d122f75d600684c2ed767d59b7ac"
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