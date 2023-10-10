class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.267.tar.gz"
  sha256 "670b2393107bed8da1844654e60bf52a45a628f47bf7cf741f4097fb983fd8e6"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4171d1d4d4b8d0e13dc5250d59b902b2662140dc926f049e6b2a49427965ddea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c720cfc5bcd1ade4592804328a2a17b3ff017e1d815e00eecd48f30aa3496087"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f525d2c781c9c6149a6fb25ce4ee802be8edef9cb05da006f8be080d950b96d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f94150a313058f51138423d743953d02dca30ca1e81d147e0a944a410c91f2f1"
    sha256 cellar: :any_skip_relocation, ventura:        "890dde383945ca26dffac7eca7cf9a6d51d41f1d903d7927a8722d484fa8a043"
    sha256 cellar: :any_skip_relocation, monterey:       "b6370d401c2d7281edb37b5ebfb2ed0612e24c1e7285801e2ea4206c5178b8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "495324f7f5e5b42b579ed8e714327bcdec618b0a6383cb82bd8153603e89a121"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-headers"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"
  depends_on "vulkan-utility-libraries"

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
      VK_LAYER_KHRONOS_shader_object      Khronos Shader object layer      \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_synchronization2   Khronos Synchronization2 layer   \\d\\.\\d\\.\\d+  version 1
      VK_LAYER_KHRONOS_timeline_semaphore Khronos timeline Semaphore layer \\d\\.\\d\\.\\d+  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match Regexp.new(expected), actual
  end
end