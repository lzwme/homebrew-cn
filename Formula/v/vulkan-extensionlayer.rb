class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.274.tar.gz"
  sha256 "100ccf35f4b54afe9601374f2aadee8b6dc24cde7273b31d1432192a0c52c2bc"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c979faa463f54ee8a187b9b087c7a8daa638fbf4bc2566837eaa663bb43fc1c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11bc0f31e6524c277214361485c9a6396b087891a6336afc2884e96b52e67908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36068155387b4e9ddc97123266270fa74dbf600b7c8263dd863e78d8cda04679"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6ec5c473a24b0048048693be91349346855ef3f1055d76391c68fbaecb52c91"
    sha256 cellar: :any_skip_relocation, ventura:        "f87f976639b89043dadfd234bf70ad1afd0e3d62b069776c3f3c95a19a0c077a"
    sha256 cellar: :any_skip_relocation, monterey:       "fa011398372a057abf0f6c5eab4a8642556a4b9ef6fadbc4e9fd36b5f30bd88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63189fccb3f6e08d963faa72391e390bfb6bb19ae9bfe9d0f5532207f0bbc4fa"
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