class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https:github.comKhronosGroupVulkan-ValidationLayers"
  url "https:github.comKhronosGroupVulkan-ValidationLayersarchiverefstagsv1.3.295.tar.gz"
  sha256 "9fa6290cb76d833f7b1ee56b504c964a07ddb9fe1e1c53456e0efcd45a8336e3"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ValidationLayers.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "729c322888811c3e7d75776f535bbed3edbbff478fbe43d7535bf5f1672ca431"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdc342e19a3eaf0a163c4d9945be4416c31f15595305e7bfecbe2ca6a8253efe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02c2067408bdea6b91e2062f129a4149fec1a2182b78961795b23f0fb6a2de0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d008a9c4e15ab98670dbd4de32dc45413394a16156469e6feefde1d3458d98c2"
    sha256 cellar: :any_skip_relocation, ventura:        "366bc13a2e5fe0e6746e7c867d8e36e76731390f2ea5d2c6e6f499da18177554"
    sha256 cellar: :any_skip_relocation, monterey:       "16c9ea66f1efe3dd89ed7134ef04d0192172ddca525935ef9cc4953ccc950ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33105ed47c902524ef1241dbedd045c90356bd0a22a95da0813a92d8ce48201"
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
        revision: "f013f08e4455bcc1f0eed8e3dd5e2009682656d9"
  end

  # https:github.comKhronosGroupVulkan-ValidationLayersblobv#{version}scriptsknown_good.json#L46
  resource "SPIRV-Tools" do
    url "https:github.comKhronosGroupSPIRV-Tools.git",
        revision: "363486479d4c8dfbfdf2e2dc397cd10aa15f80b0"
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