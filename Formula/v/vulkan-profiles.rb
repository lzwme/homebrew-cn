class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https:github.comKhronosGroupVulkan-Profiles"
  url "https:github.comKhronosGroupVulkan-Profilesarchiverefstagsv1.3.294.tar.gz"
  sha256 "21b640974f38569c9b5536b682ab9c2e9329387b98361eb3ee7136ffb61ba30f"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ea0c9ef10aceb58ac68aa6f42a39c554c2fb36f17273c3ca9cddc23c7f68973"
    sha256 cellar: :any,                 arm64_ventura:  "33a431974abcf069d39de2102c2a0db6112841a8edec31b3c3ad05d35c273c0d"
    sha256 cellar: :any,                 arm64_monterey: "1a76ed68f2c7b4e9a90a03e65118121630a6731c84318ffa009d690b7fdd37e1"
    sha256 cellar: :any,                 sonoma:         "e593b87b5174519a6b13b6402d18e57ecc88314cdc85829ce53e37df4f11a149"
    sha256 cellar: :any,                 ventura:        "88a90d92503a1ac11cb8a47a6585b6a333129a3c9687a87ad13ed276bb2edba4"
    sha256 cellar: :any,                 monterey:       "9a95da371428ee6821f467979b0383023226c1cc884c6606c11447309a35ed0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea897d3797bef8d85d4a760ddf1f25c28b9d2e6806a650ee1391664d37ee835d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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
    inreplace "layerCMakeLists.txt", "jsoncpp_static", "jsoncpp"
    inreplace "profilestestCMakeLists.txt", "jsoncpp_static", "jsoncpp"

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
        export VK_LAYER_PATH=#{opt_share}vulkanexplicit_layer.d
    EOS
  end

  test do
    # FIXME: when GitHub Actions Intel Mac runners support the use of Metal,
    # remove this weakened version and conditional
    if OS.mac? && Hardware::CPU.intel?
      assert_predicate share"vulkanexplicit_layer.dVkLayer_khronos_profiles.json", :exist?
    else
      ENV.prepend_path "VK_LAYER_PATH", share"vulkanexplicit_layer.d"

      actual = shell_output("vulkaninfo")
      %w[VK_EXT_layer_settings VK_EXT_tooling_info].each do |expected|
        assert_match expected, actual
      end
    end
  end
end