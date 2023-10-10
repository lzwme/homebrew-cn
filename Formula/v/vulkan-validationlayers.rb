class VulkanValidationlayers < Formula
  desc "Vulkan layers that enable developers to verify correct use of the Vulkan API"
  homepage "https://github.com/KhronosGroup/Vulkan-ValidationLayers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v1.3.267.tar.gz"
  sha256 "c954d9ca43683ddd51499a1b743af4d243b4432983906f87889be8ade2b3cc23"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ValidationLayers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b620b857d08f71b55e2951225ec6d47069446867521c996d76c3b56f76310acd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33cffcd4849d035bee5562df6a7bf6e378142cf213873cff868ef03292907c61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34b35420068b2a2071fea47ce122c212476e8eb2e5e76bf395d214b760645905"
    sha256 cellar: :any_skip_relocation, sonoma:         "37a1bf2713e2315100e6705f7e0c9f47f90b08098a506fc282c38ea07543ca65"
    sha256 cellar: :any_skip_relocation, ventura:        "c6aecadbf8bb653029cf81e0799c1b04041c3301f28129ef2611930815d3eaee"
    sha256 cellar: :any_skip_relocation, monterey:       "83d28feafaf9540cd42342281f6f153b6c6faee255bd6104526adf63635eac85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b1a197178f21e4f847e53059d1ac450850770a6db4b0adff0159f29d2b4df37"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.12" => :build
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
        revision: "847715d6c65200987c079fb13ca7925760faec23"
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