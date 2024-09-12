class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.295.tar.gz"
  sha256 "271527cd0ab0576b413f2616a204c85fede6c263daaf70394ca50a2d6f7fb201"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3847470c4afd5a1ffe19318015eafb55010b7fd8d15104253298cf2df931edea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61c08a85655fc2c1d6cf01d57424e0764d4a7831fbc70a8a8beafb493ed39797"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd34361498230085105e8cc6c4aec492fc2c378acf1e4c5e08e42b4be3c59568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e79992abf9bc3f93d43eea157b07cd0212c9c263e082cc14e243f61952a2dfac"
    sha256 cellar: :any_skip_relocation, sonoma:         "486e7763fb8c94f242b7627290b6b33d939fae705f9b36ee1a67fc4da86449db"
    sha256 cellar: :any_skip_relocation, ventura:        "1baac413caf66dc4519c1673f2c34d7516952ae6b3f5e94b1684a85d07973916"
    sha256 cellar: :any_skip_relocation, monterey:       "2f371bde7de2345dfb5e2e72b8201600775f55ffcb6aa32719638ca3db03cd3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c15a70233e55a48afbffed4a3b4b4e52147ee8851ed98ffed23a33ece2d4364"
  end

  depends_on "cmake" => :build
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