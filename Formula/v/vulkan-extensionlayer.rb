class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.290.tar.gz"
  sha256 "fff865f9fcfb5de8867dd0511b68dcf19a1847b18d3f1b5d974be393412f07e8"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66b9e7962a8933d80e1289f222f7ef80aea472040eed269bdd4fd64c982cfd97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "868fb1f1aa2294881f9e2e86899e9f5cca025e63ec449320a0240e2e04c49f65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cf2d35e8f569f72f760644bfe33b7d5041465985c94ed27910548b7c1482a2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4fd0b9a379b03f3a2777b8822de6f6c9ed34bc8d30bbdc9889c5d7af160e51e"
    sha256 cellar: :any_skip_relocation, ventura:        "ada194ddcdc91b6014e334582a0609e571ce703fdf979f7dc58fd6f903cab04c"
    sha256 cellar: :any_skip_relocation, monterey:       "51be1c1bb1d3e5e2b6209fc8408660ad57cd29e77cdfbe66a9b9832341dde038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09047a414827151b6d499e1626a77b7d01c5ef87de1fea7b90d69a899777bb4a"
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