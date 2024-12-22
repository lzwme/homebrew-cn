class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https:github.comKhronosGroupVulkan-Profiles"
  url "https:github.comKhronosGroupVulkan-Profilesarchiverefstagsv1.4.304.tar.gz"
  sha256 "36505936722415ac3a75ddf3034aff8473512ecdb7a12a01f9b714fbf5219723"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27634f0895dcbed96fdd76733720547e2266af4c60638f25d99d5f92cc44ad2f"
    sha256 cellar: :any,                 arm64_sonoma:  "867353f74a010e3c234f87e9d4aa0b7dbae4fda12fc17918701e63cecc550245"
    sha256 cellar: :any,                 arm64_ventura: "33008915207178fff41c4e920f68fa520dd95d9ff3b1eaa89a0e2ed78b86bcd3"
    sha256 cellar: :any,                 sonoma:        "0f43a5ab040a29c03b862873af17547b881d72a147d7e0663f9044962362d2f3"
    sha256 cellar: :any,                 ventura:       "9fc7ec165d179ea54b93870ed40a9fefd4bec7182fc70738270588622406be0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce06837d87c7013971af35b7dbd1de5df29f5b39e259f4ba6226fe394a63c921"
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