class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/v1.4.323.tar.gz"
  sha256 "7f9b7a2ad71bed97cc660d2fd0448cb82e5b10674e851936f4ba5a6595d13c6e"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7aa662bbb57578366ff34ef416a6be7397f9536620bacb241d3afa1673c7a2f9"
    sha256 cellar: :any,                 arm64_sonoma:  "51023c10caad84cf1928feac10ec5fa341efa622f1026966762fd25de13c3f5d"
    sha256 cellar: :any,                 arm64_ventura: "a3ea2fb01d0df23fdc1722cc4259a1329dfc9345b982a04f786092d26fb10d2e"
    sha256 cellar: :any,                 sonoma:        "6f6e22b3d30b7ec279f49b0e5f28335c8d7f0d36283c880c14e1f9cc98f3de56"
    sha256 cellar: :any,                 ventura:       "81a19fd21d6cd80b1cb7683df1cadccd83e51bb6e1c9b5acfe22ab9d3f4dc040"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d75caa57413ec3aafa75db3cc825ed27023f592022d21b69a62a907cb2962d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3065be610329d6dcc2164b3b3b19f01c8ac2062d0379e82330b729169b8e0dcc"
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