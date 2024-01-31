class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https:github.comKhronosGroupVulkan-ValidationLayers"
  url "https:github.comKhronosGroupVulkan-ValidationLayersarchiverefstagsv1.3.276.tar.gz"
  sha256 "37a7ec55817a310dd473636a5c996708be55871ba4e211e8b63982054da06b3b"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44253807f40161ffed9a8fd3c63bda6b5f657e3aa0d825eec54be9d90df7f36d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "213e0342960602bce6355e9b2de1fa57c0fc223a06b80bf1c6a5d316fec19023"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5b71314d84a7d5ecc6543f13d7f085de42ecf0b5af8cf1e0f335b2b3e1fe685"
    sha256 cellar: :any_skip_relocation, sonoma:         "051457ae8f87b960eea36155d7661c86b27c347e60a2829db95d5d00d464e88d"
    sha256 cellar: :any_skip_relocation, ventura:        "e912a7319321dd58db92d5cf177b1eb4eba2171b33ae2a9cb12fb648f314d070"
    sha256 cellar: :any_skip_relocation, monterey:       "e5e716d1182a5efa42f5318331d0585414c65bc0fd317548d7a5e83e07127c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed31ba178e2074779cd1d7f23319d403a5c624e1dd15132cad724b691a9b239"
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

  # https:github.comKhronosGroupVulkan-ValidationLayersblobv#{version}scriptsknown_good.json#L32
  resource "SPIRV-Headers" do
    url "https:github.comKhronosGroupSPIRV-Headers.git",
        revision: "1c6bb2743599e6eb6f37b2969acc0aef812e32e3"
  end

  # https:github.comKhronosGroupVulkan-ValidationLayersblobv#{version}scriptsknown_good.json#L46
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