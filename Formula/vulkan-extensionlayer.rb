class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.257.tar.gz"
  sha256 "27227d904072228b44fea3e2b766fffb03fb0acc0864ac3c917ce399b0516676"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03947ff69e3fdf052b2617fe0e3fc9e7d023df45eb69c96a17a26edab93ea6de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "895fdd9ff40724b59bbfa135a9a54d6deaf16f28cc6a280e712f8df2bf18e5a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2df1acedfe46f0e04c06694a1b14f1b3a6fad7acc7b2b59c0c436febfb11b1b0"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae8ef0d0996cc2a2cb295043004716d6c3c16843d87cc23547724e9e0b7463b"
    sha256 cellar: :any_skip_relocation, monterey:       "bc0cdc11ccea7e611d2c82ace1988e80f6ef0db8e704513de166725e3e7dd7c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9f1efb170b6a432c3467bc711c6c34595249fb17b0ad17cd17978cf1e41b93a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2b0935832a9fee79afd7c885f4b4404ba1dbef709a0ea5de8422aabaed7037"
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