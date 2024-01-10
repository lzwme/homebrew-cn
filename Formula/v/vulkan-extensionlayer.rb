class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.275.tar.gz"
  sha256 "3c4227c78d55c33a36a6fa22de551fab023056a358c97a674f57d4096e8e0b6c"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6d9818f862defa182196030bac2dfcf0609f7dd46df74c3872797443a383dec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848bbe912fe911c59605460e694050ef146bb95d5a4bf1024866ea8aacca31ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ff5e327de6d82cd7195789ba494d04aae36fefe9e3c00506b9b8b7f3c55254b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4a19dde45f855b6bf9b2a54e0908ec9c28f40abc6912485562c6a52a64ec6b1"
    sha256 cellar: :any_skip_relocation, ventura:        "d468b1cdb431091f47f4005b6127262b489802391d3abad3601c73cfec634447"
    sha256 cellar: :any_skip_relocation, monterey:       "49d8c0f9eee584377604625823d9190ab19e4c9a22c24e85154b1ce56049b104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d67f3119d051269aaf988d2e755a6e720624cc9d0ac25ee99d35d4cd5ed1caab"
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