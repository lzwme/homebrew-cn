class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.293.tar.gz"
  sha256 "d73e94959ec872ea9b4c2535423f3587abd11d73a87de678492c68a5a9302969"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0cc1ce1d00d4b6f0e4370248fc4349079c4e10bd5b238aafe791a87a55a326d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e79b87285adf53b06525b94f2dccb5c29edf22b73ae53f83adc0dcad42f4c12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcc5150d8347e373505f379a42b88e667ca69193743dbba4b72e3e27d2843f39"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bb6399648d7820d31e60dd4d1b7775321281dcf4d89e64b87c0f3b1a7cae9d7"
    sha256 cellar: :any_skip_relocation, ventura:        "48e4965fbacf20e2887065635ea284fcc4f3e625f2beafcc860bb5e7d328676e"
    sha256 cellar: :any_skip_relocation, monterey:       "c0359b01c2701623f9a972a2cf97543ce98ce11ba213da10f309577b34be672f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6a8849007ae540bb25058994572be0ee2185e5e99229c5d00b79520aeba200"
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