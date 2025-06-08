class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https:github.comKhronosGroupVulkan-Profiles"
  url "https:github.comKhronosGroupVulkan-Profilesarchiverefstagsv1.4.317.tar.gz"
  sha256 "5b33d1402e1cf35448438f6a57f4ea78c11b152b20183e2db3065a74298b7545"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a71a646a1fbedd949f9089d89b6f270dc00af580f151184aa9d538a1f0f84732"
    sha256 cellar: :any,                 arm64_sonoma:  "a53e01c9dc0dcd94d78c59fb015fde8d5891609f88bdfa5fc500406249d13fdd"
    sha256 cellar: :any,                 arm64_ventura: "0d24270f16b03da0c5e0a28626b9783361db6a30af7dcc547c128db4c6353b8f"
    sha256 cellar: :any,                 sonoma:        "f9c3a2c60c7d61cd55b2a328a22ce26897df5bfb635016adbbc40f0b3a427c61"
    sha256 cellar: :any,                 ventura:       "a273b092da5b30a40b1647091f2f984803041c67c74fd5afe15a4fffc7870a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c268941ca8c31ec1dd9701b9a4073935fa0811ad7f4a728c46fa8db852357186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f177fe82b614c50170b57ee49d22a9b566150d9353f9bd2fef27be3369c9b6e"
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