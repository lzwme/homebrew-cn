class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https:github.comKhronosGroupVulkan-ValidationLayers"
  url "https:github.comKhronosGroupVulkan-ValidationLayersarchiverefstagsv1.3.274.tar.gz"
  sha256 "3dcd107fd6d46ae07e9ae072f79c3fa326329ce2c986d1f7b61e3079bfa1e020"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78b31358444a59b19dd08ba6e43dad2677826bc07e46c0c34d1f86cfca127db7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2c4f5168dfc745b280afa0c4b4593a3a5bb64024e45c09e4af7cf651a99eecc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9022aa83b588f7a48c0e321541563fb9ee613286c77e81a6e61d8395cec3ffa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "970cef1aca2df31a4d49d6c6d98f31545ceaa2e9b342d62f2a9f95f53d4ada72"
    sha256 cellar: :any_skip_relocation, ventura:        "a9e3ad2061b93ee4bbb067a769d1e82d7f4d4a6014cf3d967077641dbc29b49d"
    sha256 cellar: :any_skip_relocation, monterey:       "047d2db7101623c10c1256bc7f52ecf4c83d46042c41de1bccfc622cf41b572b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddff9ca1ddbe03a2cb9b7c22700b4bb956912a6e9f3c6d4b501db66ea2c47006"
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
        revision: "6b4f0c9d0b7d02db5ed0b03433ae62c03bbff722"
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