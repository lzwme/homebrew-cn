class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https:github.comKhronosGroupVulkan-ExtensionLayer"
  url "https:github.comKhronosGroupVulkan-ExtensionLayerarchiverefstagsv1.4.311.tar.gz"
  sha256 "ed60fba57383d487f1d8b3fcec2bf3fb467258ac09dc57ddf86e95b46f9f5c93"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ExtensionLayer.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a29d129448d3e8f122c597aa533172e9c8c802066ff36d8fe95528d0acc80b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb958b35164908ecb3ea541cb00d4ccb35b634e5d852d8ec20d7157e019aeb65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54223d904469439a4e9233c6752a8b56e4b59f47c795e0c096e475f7140bea06"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d094efaba715d4e0ebe71f108a55e2d5f2a38be8b26c0d668b3f139f707094e"
    sha256 cellar: :any_skip_relocation, ventura:       "9f349f1c0e701c74548e55df1c6144fa8426cf45ac0429a12ab2b5fcb001fb17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1415db7442607fe8db0da52f8703ea9a1024f4a35620a8d6bc980ff3cc3ee664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55f0bdccaea400e111ab36dc3ddec816444dc79b4da51c4b1c35e5db8ecb79b"
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