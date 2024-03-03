class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.279.tar.gz"
  sha256 "09778494680cb5b84047c5689ad2585f4eba3a1fd16be4365178d8eb5077da9b"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b5d18cec427c13727e5c0b4d6836985a4c7113f6e20739e90386588872539a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02ea8577eb3c80241480dc12c19f2b6d2429c4e370b63b447f4ad18b9c3e0fc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f533ee8cf21ea46c63d864e7bb77fc262ab3ea61bfdc3e40b7ca345edc0e20cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "466f954f50e88038831738504986787b5989e717533b5e7e6fbb8e1c448fe91a"
    sha256 cellar: :any_skip_relocation, ventura:        "34877f146facda716d0a1ec22046dc0f61f811e838e0ea316dc056e64c5ff207"
    sha256 cellar: :any_skip_relocation, monterey:       "8ca7f3db95388fafbcf4f12690a30e43abbe69c0957c4c06cd9936b8263ae1bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc794303a51b0d10f82920bffcf75a25dd52f1697c7c8249d69b172532e1dc7"
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