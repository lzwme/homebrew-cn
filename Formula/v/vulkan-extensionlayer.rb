class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.3.289.tar.gz"
  sha256 "8c1cadaf3c3901d79296d1a1035e225018627c5e05e81de5dbace1ea81365d5d"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f00bc076fd4dcb83fd01060515fa8873316bbc29416c02b8424a89d5b1684324"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36b391c78d47f111f9693c49089b8d636c1702f3faeed458e427115aafb13c3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e20a1dd2160cbd7bdcecbeb3f663041e26402dcdb5479ed4f55620ee50ba0aac"
    sha256 cellar: :any_skip_relocation, sonoma:         "3953e5d4096b70354d79da80d36bc9b52c66ba75862a13521a7f4e0679d90f0b"
    sha256 cellar: :any_skip_relocation, ventura:        "d604d83f70ab0b1fc6b3c68ae2a6d9b3c493b01b5c9e5d7a9fca167b1af4a06d"
    sha256 cellar: :any_skip_relocation, monterey:       "9325c151a535da99a0bcde51d8a0e1f4771ed1171491ac7d03121961b9eda1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8646cb42520f7b36c897f9c85ca58b2d73a1bf864760b345ed3f83971f53e2ed"
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