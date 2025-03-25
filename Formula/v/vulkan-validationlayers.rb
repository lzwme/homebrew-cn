class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https:github.comKhronosGroupVulkan-ValidationLayers"
  url "https:github.comKhronosGroupVulkan-ValidationLayersarchiverefstagsv1.4.311.tar.gz"
  sha256 "d784393c9fd2b8c3f9ca71aa14cee5fd0690227e433c16895ea9c6db0e1b43a1"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-ValidationLayers.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "750276c3768680648ee80773ec89db7d72d5546acea4e25a435f66b1d2c9be94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f7b238070bf7f7b2d7215d04df083ee8c60e15d975433d7ea259b8b3e175af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f5c243fe486040149a194170ce474e79ad56244da3a63ea964640d7c00c5b59"
    sha256 cellar: :any_skip_relocation, sonoma:        "6665ad7a3aa26d639132558b93a519b0d2542f1eed355f786bd30584caaca2fc"
    sha256 cellar: :any_skip_relocation, ventura:       "42327545a2d584e52cd278faa6aef646eb7a0dad3e2e16e152f583c337f7f6d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb808d3bc224ac7033892ac647958b5c587e36cd389e0e7d6d9b27831ab0a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ba603bb66996063855590bda9ef6cccd97826cedb6bdd81a57b50b3289bcd62"
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

  # https:github.comKhronosGroupVulkan-ValidationLayersblobv#{version}scriptsknown_good.json#L32
  resource "SPIRV-Headers" do
    url "https:github.comKhronosGroupSPIRV-Headers.git",
        revision: "ddd2c099be25e3fec7cdc14106c17aca99512082"
  end

  # https:github.comKhronosGroupVulkan-ValidationLayersblobv#{version}scriptsknown_good.json#L46
  resource "SPIRV-Tools" do
    url "https:github.comKhronosGroupSPIRV-Tools.git",
        revision: "ba1359d203e544bd458373ba249a47c44e97b071"
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