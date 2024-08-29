class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.294.tar.gz"
  sha256 "2c95779543d726f619b3bbacec0c71b2e8660b16989c39c41d4050d609a1fab9"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "224214e743cdc011f9fdf0ad2277d951b0b0610f3478895cb4bc4b876a04559e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24e312b3b1622e3bd2775f225b153b159fe35fa05f0b6ce702241e7d8898baf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56194148633b43cc4cc273da907b9bbc33509f480198e3807d2dd661e0c05b88"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7e51aa96818d3dc8d34db3f36e5b93379068a99e7f4705a011253345498f386"
    sha256 cellar: :any_skip_relocation, ventura:        "7ff1e428a19d164fc9876a4792bec1c6aaf214d03883fc14a989d00dd19b2224"
    sha256 cellar: :any_skip_relocation, monterey:       "ff4af3c78f0fc7b343aa5509a5340dad3136cd87905d2cacb6ec22722c283161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981601afb0d386993abe15f7b7bf5783a7404f24f1e2d71640f0fdf6daa7234d"
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
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use these layers in a Vulkan application, you may need to place them in the environment with
        export VK_LAYER_PATH=#{opt_share}vulkanexplicit_layer.d
    EOS
  end

  test do
    ENV.prepend_path "VK_LAYER_PATH", share"vulkanexplicit_layer.d"
    ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib"mock_icdVkICD_mock_icd.json"
    ENV["VK_MEMORY_DECOMPRESSION_FORCE_ENABLE"]="true"
    ENV["VK_SHADER_OBJECT_FORCE_ENABLE"]="true"
    ENV["VK_VK_SYNCHRONIZATION2_FORCE_ENABLE"]="true"

    actual = shell_output("vulkaninfo")
    %w[VK_EXT_shader_object VK_KHR_synchronization2 VK_KHR_timeline_semaphore
       VK_NV_memory_decompression].each do |expected|
      assert_match expected, actual
    end
  end
end