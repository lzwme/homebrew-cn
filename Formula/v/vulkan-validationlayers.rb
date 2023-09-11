class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.3.263.tar.gz"
  sha256 "7e1370b7eb38c4a3ef4afd0bd36393e4b0602dac8a2366c08eabd8f19ceb1e8f"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "852b50c9819022aeb8024a1fd871db8eabaa2f845d70cd411aa71a70a25e6dfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b89ee5a61681fe5a539ba1fac438aac420b325e7a0aab5e254e80568d819095"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44e1bd2bdcbef3f2ed87ecc8a51e06a16624e99cf5b436b5b644eb900765f0e3"
    sha256 cellar: :any_skip_relocation, ventura:        "e28c67704002848abea87187572973d37fc21442181cd105d2b5e9a8626dcd44"
    sha256 cellar: :any_skip_relocation, monterey:       "b3fc9421b0b17c35c9a5d74f3c6d24d3dcc6dd8bce3a6144133493cedadce1a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "20bfa6843a726914d4a5c3e9f64079219b4319a20984c2525fadc82df2d1c860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4434a19e3587bc993c6b602aa88d57111a47d7170fbd9ac303850e92f5d28187"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "vulkan-headers"
  depends_on "vulkan-utility-libraries"

  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#43
  resource "SPIRV-Headers" do
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "d790ced752b5bfc06b6988baadef6eb2d16bdf96"
  end

  # https://github.com/KhronosGroup/Vulkan-ValidationLayers/blob/v#{version}/scripts/known_good.json#L57
  resource "SPIRV-Tools" do
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        revision: "1b3c4cb6855f7db1636985e1652ebbf91f81cd50"
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

    expected = <<~EOS
      Instance Layers: count = 1
      --------------------------
      VK_LAYER_KHRONOS_validation Khronos Validation Layer #{version}  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match expected, actual
  end
end