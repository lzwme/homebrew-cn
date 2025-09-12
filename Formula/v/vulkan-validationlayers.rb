class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.4.326.tar.gz"
  sha256 "41b0a3d5b8a0a1ed395650adfc453b9711ee02c27abdc27845dc58c683d31268"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb4e0918a4afe06ff03661e6443221ef2556d16c2e73c3693739fb9747180181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f56989c5a3b359d448ee2893d2508046a64c285c31b35ea92ad2b33b33ed03b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae729c20f262dffbbd3c31281629e7c26e1fc0236103c21eafda5ad54ccf84e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "624ea7227f49f8fd45ea615d30eb1c19444fd8ff5485cbf385179a532a82b616"
    sha256 cellar: :any_skip_relocation, sonoma:        "e79cb999b73934574c1041deec7b8855714dab93036b8aeae77c0621ad31533b"
    sha256 cellar: :any_skip_relocation, ventura:       "2a80a4cb4418116ee0662bc814c95f2b919acd4464362c1b378153ac73b0d3dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c45bf0c1f281d4cfa08d029f75eea2cf91dc7d5d1f1657d19dea1ff4feec1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3caf9efe8dd0e9cee6004fa2cf71bf4c732b5d6fe1a075ee3e87d9c5844f01e4"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"
  depends_on "vulkan-utility-libraries"

  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "pkgconf" => :build
    depends_on "wayland" => :build
  end

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#L32
  resource "SPIRV-Headers" do
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "e6d5e88c07cc66a798b668945e7fb29ec1cfee27"
  end

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#L46
  resource "SPIRV-Tools" do
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        revision: "fda5a216e9d25fa2eeda73ec8436b96e395ce5d5"
  end

  def install
    resource("SPIRV-Headers").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"third_party/SPIRV-Headers")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("SPIRV-Tools").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DSPIRV-Headers_SOURCE_DIR=#{buildpath}/third_party/SPIRV-Headers",
                      "-DSPIRV_WERROR=OFF",
                      "-DSPIRV_SKIP_TESTS=ON",
                      "-DSPIRV_SKIP_EXECUTABLES=ON",
                      "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
                      *std_cmake_args(install_prefix: buildpath/"third_party/SPIRV-Tools")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    args = [
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
      "-DSPIRV_HEADERS_INSTALL_DIR=#{buildpath}/third_party/SPIRV-Headers",
      "-DSPIRV_TOOLS_INSTALL_DIR=#{buildpath}/third_party/SPIRV-Tools",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
      "-DVULKAN_UTILITY_LIBRARIES_INSTALL_DIR=#{Formula["vulkan-utility-libraries"].prefix}",
      "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
      "-DBUILD_LAYERS=ON",
      "-DBUILD_LAYER_SUPPORT_FILES=ON",
      "-DBUILD_TESTS=OFF",
      "-DUSE_ROBIN_HOOD_HASHING=OFF",
    ]
    if OS.linux?
      args += [
        "-DBUILD_WSI_XCB_SUPPORT=ON",
        "-DBUILD_WSI_XLIB_SUPPORT=ON",
        "-DBUILD_WSI_WAYLAND_SUPPORT=ON",
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use this layer in a Vulkan application, you may need to place it in the environment with
        export VK_LAYER_PATH=#{opt_share}/vulkan/explicit_layer.d
    EOS
  end

  test do
    ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"
    ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib/"mock_icd/VkICD_mock_icd.json"

    actual = shell_output("vulkaninfo")
    %w[VK_EXT_debug_report VK_EXT_debug_utils VK_EXT_validation_features
       VK_EXT_debug_marker VK_EXT_tooling_info VK_EXT_validation_cache].each do |expected|
      assert_match expected, actual
    end
  end
end