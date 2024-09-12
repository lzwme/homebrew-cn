class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https:github.comKhronosGroupVulkan-Profiles"
  url "https:github.comKhronosGroupVulkan-Profilesarchiverefstagsv1.3.295.tar.gz"
  sha256 "9f44e8c7814750b0bb6b5558d1b236579edf7a20b65f018d6d22a1c35af5d7e1"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "584257aa41a6ed46a9dbd4e13dcfee8105241b02231b867be56ae2f5e4b5c3d2"
    sha256 cellar: :any,                 arm64_sonoma:   "6e9053788cd013c8404d78e7e3e95812527f89b24e4cea5543f702b0f95b8b18"
    sha256 cellar: :any,                 arm64_ventura:  "fe0a026bec29eaec06060093b53b2015c69472d134ed00ac6c8b63704b3c35fd"
    sha256 cellar: :any,                 arm64_monterey: "aff171d7d4ee2973bb5e285d199581b335a2b66138b74645d8caf8fcb345accf"
    sha256 cellar: :any,                 sonoma:         "4754983e2dde13428e7131da480500d5517c53bc680dd6c6a9e33b3095a058b6"
    sha256 cellar: :any,                 ventura:        "accdef86c09bc1c1aa0888aacc92a87a57eb91a27d1dd9097e3c84af22539123"
    sha256 cellar: :any,                 monterey:       "4571370b82d6ee965360356256e30da2fcf99dea34666d0939c81868df6d1ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0cca15eedb25fc8a4806c120dd90c73e9fa6d0500c07419fb54ba65669bfd0"
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