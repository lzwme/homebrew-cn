class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.4.304.tar.gz"
  sha256 "168cd5b69f54e82d7fa670d9187a43270b843e6dda21330ced43d6c85a050317"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82f9b95a7cc538d2fd8625910d2a482747332de2a04a944f00b8949b29c29337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5265c0f75df7bf28c45d103816dfcff27d9aed8e89db54de2beaa4e656eeb954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdd4365ea6c282827114a8d93dbea9896ff99ea35e853a9ccc0c137b53c3bb2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "24332fc51aec92163e9c28d76fec1ec68231a344824d99644c99fc34586f9662"
    sha256 cellar: :any_skip_relocation, ventura:       "de2de57f69f6a7276cecafaa8ba01a4fdb1a2046dc20b1b9fb46aa2d206289db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8bd99277558e839af8a916213a9a2da6935d0a8eb5c22211dcc82e8d22e417d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
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
    depends_on "pkgconf" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTS=OFF",
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