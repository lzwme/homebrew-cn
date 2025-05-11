class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https:github.comKhronosGroupVulkan-Profiles"
  url "https:github.comKhronosGroupVulkan-Profilesarchiverefstagsv1.4.315.tar.gz"
  sha256 "ea2c45304206e23789ce57117d5155f1cc3c8ad8fa636e0fb32891e1c01ca4b8"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc7933980f568e7439dd2e28cf344bbe547438a61938b2bf9c080f539e8c2931"
    sha256 cellar: :any,                 arm64_sonoma:  "60c9ec07733d9beb0116e1708308207fbafe17fa36633f2d1d2fee3dd3184bdd"
    sha256 cellar: :any,                 arm64_ventura: "f8a3ce10f8a620eb00a2c9e2fb1ac4384f2cda09d237404dd41b729bd1be8111"
    sha256 cellar: :any,                 sonoma:        "bd81bcb6a3752de8f32bc16941594c7efaaa36350fde18f7e60e288e5e6976a2"
    sha256 cellar: :any,                 ventura:       "1d2fdf67c932e160440cf28880e2af6958beec47bcb69a2ce00bd889249a3bf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4d31d9fe16d203f4fa8a612cc90c134ae4019c6ebc9e47e0db13cb48b037013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7879c75d098cad1c8a58b7fab1cf337cb3c5f541e17aab8a2edb6ab71ac6141"
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
      assert_path_exists share"vulkanexplicit_layer.dVkLayer_khronos_profiles.json"
    else
      ENV.prepend_path "VK_LAYER_PATH", share"vulkanexplicit_layer.d"

      actual = shell_output("vulkaninfo")
      %w[VK_EXT_layer_settings VK_EXT_tooling_info].each do |expected|
        assert_match expected, actual
      end
    end
  end
end