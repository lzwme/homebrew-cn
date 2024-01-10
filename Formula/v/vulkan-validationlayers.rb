class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https:github.comKhronosGroupVulkan-ValidationLayers"
  url "https:github.comKhronosGroupVulkan-ValidationLayersarchiverefstagsv1.3.275.tar.gz"
  sha256 "bb18e236c8f5abdf2229f9657d0a18c965f297b81baa3a48dc72213bcbbf2df4"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37d3966f91a7dce0af60abb21597b2ad25e51959e889c7727f5f6a319626e897"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5098a711a1e344e94e2288df8a6ed34c1036ec67959f7994ce8dd0af547ce7d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce6b41bfeb2a0a97689f2023e13311f1cb603a3a5db45c8a2ff031bd0d42500b"
    sha256 cellar: :any_skip_relocation, sonoma:         "74814ed164b8cf934f71f8b360722260821dec0780aa2daac0151d7c53483808"
    sha256 cellar: :any_skip_relocation, ventura:        "b3f623694d7625f37e4328251a56cbb4732dcbf84b895814980d43e9fd13b439"
    sha256 cellar: :any_skip_relocation, monterey:       "969159376efd12f98bc2475710f49205f3e54ef4ac0651f9ff50724f270cdf60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e5300fb7a03689bba27d882fbea3d5e48f9ddc3aef3b43ea3f436bd2d04765"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"
  depends_on "vulkan-utility-libraries"

  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  # https:github.comKhronosGroupVulkan-ValidationLayersblobv#{version}scriptsknown_good.json#43
  resource "SPIRV-Headers" do
    url "https:github.comKhronosGroupSPIRV-Headers.git",
        revision: "1c6bb2743599e6eb6f37b2969acc0aef812e32e3"
  end

  # https:github.comKhronosGroupVulkan-ValidationLayersblobv#{version}scriptsknown_good.json#L57
  resource "SPIRV-Tools" do
    url "https:github.comKhronosGroupSPIRV-Tools.git",
        revision: "f0cc85efdbbe3a46eae90e0f915dc1509836d0fc"
  end

  def install
    resource("SPIRV-Headers").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath"third_partySPIRV-Headers")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("SPIRV-Tools").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DSPIRV-Headers_SOURCE_DIR=#{buildpath}third_partySPIRV-Headers",
                      "-DSPIRV_WERROR=OFF",
                      "-DSPIRV_SKIP_TESTS=ON",
                      "-DSPIRV_SKIP_EXECUTABLES=ON",
                      "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
                      *std_cmake_args(install_prefix: buildpath"third_partySPIRV-Tools")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    args = [
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
      "-DSPIRV_HEADERS_INSTALL_DIR=#{buildpath}third_partySPIRV-Headers",
      "-DSPIRV_TOOLS_INSTALL_DIR=#{buildpath}third_partySPIRV-Tools",
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
        export VK_LAYER_PATH=#{opt_share}vulkanexplicit_layer.d
    EOS
  end

  test do
    ENV.prepend_path "VK_LAYER_PATH", share"vulkanexplicit_layer.d"
    ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib"mock_icdVkICD_mock_icd.json"

    actual = shell_output("vulkaninfo")
    %w[VK_EXT_debug_report VK_EXT_debug_utils VK_EXT_validation_features
       VK_EXT_debug_marker VK_EXT_tooling_info VK_EXT_validation_cache].each do |expected|
      assert_match expected, actual
    end
  end
end