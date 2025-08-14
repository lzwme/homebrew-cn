class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/v1.4.325.tar.gz"
  sha256 "09bb074e3e67675c002a84726e70ad1bc70c3a74a66d5a82272cb5483878267b"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf4aa042948f090e0a29c2eaad947651f23474952d38f13ca622276197fc7ad4"
    sha256 cellar: :any,                 arm64_sonoma:  "0b6e59737864ac8f63538d4ceca609d8148d2264b2c3bd1f4707de6f67cbe3bc"
    sha256 cellar: :any,                 arm64_ventura: "0b0e81d744f739b987fd93d1501f336bbe67141331780c64c3b5c70f12c91873"
    sha256 cellar: :any,                 sonoma:        "28367160c912cf143784202eb2ed91682b3f1eb2e3e5d968b545f2a50e676a9a"
    sha256 cellar: :any,                 ventura:       "95bdabed8383ea2680ca1cfdf674176b4fbfe28d014940ad96240a81c3a3c47c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ade1466bc4ce021a55da891dab0c28645f4733faeb89ca9128869eab56ac91a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05f9432fa43baffb3e498afee31c01cd3f3a1c96852f826322fdc36cee4fa6bf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-tools" => :test
  depends_on "jsoncpp"
  depends_on "valijson"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"
  depends_on "vulkan-utility-libraries"

  on_macos do
    depends_on "molten-vk" => :test
  end

  on_linux do
    depends_on "mesa" => :test
  end

  def install
    # fix dependency on no-longer-existing CMake files for jsoncpp
    inreplace "CMakeLists.txt",
              "find_package(jsoncpp REQUIRED CONFIG)",
              "find_package(PkgConfig REQUIRED QUIET)\npkg_search_module(jsoncpp REQUIRED jsoncpp)"
    inreplace "layer/CMakeLists.txt", "jsoncpp_static", "jsoncpp"
    inreplace "profiles/test/CMakeLists.txt", "jsoncpp_static", "jsoncpp"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["vulkan-loader"].prefix}",
                    "-DVULKAN_UTILITY_LIBRARIES_INSTALL_DIR=#{Formula["vulkan-utility-libraries"].prefix}",
                    "-DVALIJSON_INSTALL_DIR=#{Formula["valijson"].prefix}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use the provided layer in a Vulkan application, you may need to place it in the environment with
        export VK_LAYER_PATH=#{opt_share}/vulkan/explicit_layer.d
    EOS
  end

  test do
    # FIXME: when GitHub Actions Intel Mac runners support the use of Metal,
    # remove this weakened version and conditional
    if OS.mac? && Hardware::CPU.intel?
      assert_path_exists share/"vulkan/explicit_layer.d/VkLayer_khronos_profiles.json"
    else
      ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"

      actual = shell_output("vulkaninfo")
      %w[VK_EXT_layer_settings VK_EXT_tooling_info].each do |expected|
        assert_match expected, actual
      end
    end
  end
end