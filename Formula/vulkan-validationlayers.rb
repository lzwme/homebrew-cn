class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.3.248.tar.gz"
  sha256 "2b4d62fe0a4392b1a322e3d2c8a3541ee19074363c7464aef029890143ecf521"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17e804049455e310d29aef71542376e425fe26cc421ef47c33b97248c3958d04"
    sha256 cellar: :any,                 arm64_monterey: "1dc80cc863e06698e4cdf60b20cc7bdf1e5e951774b0cd1a9bbd6fdd4c25e520"
    sha256 cellar: :any,                 arm64_big_sur:  "0523325168764a438553037cca0791f7a307add39d8040b5c9f31740028d1bce"
    sha256 cellar: :any,                 ventura:        "5bbd8fa8d568c0f07d6651c10e56ba571d09941a491773dbd4f92aa4da1833d2"
    sha256 cellar: :any,                 monterey:       "811fb5a1b0f1e7859d089a1dcef3721d6415012c6fdf534d96e7285f331d4f96"
    sha256 cellar: :any,                 big_sur:        "fce58f2a19936a0c5b08bd493ce727157d264140bac7a7c41d293da6c7bff83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0773cb997c323e0e6d1791e2bc32091aad043e37b346206d53f9380933a8669"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-headers"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  def install
    args = [
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
      "-DSPIRV_HEADERS_INSTALL_DIR=#{Formula["spirv-headers"].prefix}",
      "-DSPIRV_TOOLS_INSTALL_DIR=#{Formula["spirv-tools"].prefix}",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
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
      VK_LAYER_KHRONOS_validation Khronos Validation Layer \\d\\.\\d\\.\\d+  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match Regexp.new(expected), actual
  end
end