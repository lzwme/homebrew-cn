class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https:github.comKhronosGroupVulkan-Profiles"
  url "https:github.comKhronosGroupVulkan-Profilesarchiverefstagsv1.3.295.tar.gz"
  sha256 "9f44e8c7814750b0bb6b5558d1b236579edf7a20b65f018d6d22a1c35af5d7e1"
  license "Apache-2.0"
  revision 1
  head "https:github.comKhronosGroupVulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7356dbb710d2a77c7cfacfa3305f6f48e1535648543d10c69b7176baa40e9687"
    sha256 cellar: :any,                 arm64_sonoma:  "55b99fc766084c7d3e30b15b0a4cd2a3f9cd122e279aee68c793c61bcc8edf65"
    sha256 cellar: :any,                 arm64_ventura: "4e9276b15129bb72dc7e62518bb5aeaffb0956ac8c8013734160b92c81f5bc88"
    sha256 cellar: :any,                 sonoma:        "d952dc323bdae82fa7c3087d6cb80da9497aee6c8105222d01253af83b620ccb"
    sha256 cellar: :any,                 ventura:       "5aebde1a704d94ee79be423120b1fa31da1a587be93b28db32ec0acdcb608545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "824491b851bb889ec3d8a33d93e0699c1a5109f4b07fd96d44b28d6d63ffe0f1"
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