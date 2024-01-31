class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.276.tar.gz"
  sha256 "dd816537060d8e7f0f6d3ccba611fcbfe92f30c078f8e9d16c9e734fc1fa91a3"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd998647c44d1c090768e9f27ba2d6b3eddd75bd2cf2b0baedbed65b6f85326c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202b10ef9ac0f303ba29127b9238d457c163a613dcf95f53edf336e9be5d3134"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b10e2044d1a7d3d0e85202293d4f9a485fe86a838be77095fc284b6ad3d8580d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6951c585dcb01f2556ad50d68b92334d804db45b4e6a6aecd5d05bb3d64d2f4"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ae407236a4b7598d6662b62fc9a3babb25a4d8ed6d7b1b4f5d8eaaedc9a1e7"
    sha256 cellar: :any_skip_relocation, monterey:       "8150160f718a018ca35eba9ed8300a73c75fad86b0ba5324d5eb88779a22c8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afede6efea3fe112cbf392b1b29a8f1817caf2bcc6be21e85e1fbfd2d66e90e1"
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