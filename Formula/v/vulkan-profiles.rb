class VulkanProfiles < Formula
  desc "Tools for Vulkan profiles"
  homepage "https://github.com/KhronosGroup/Vulkan-Profiles"
  url "https://ghfast.top/https://github.com/KhronosGroup/Vulkan-Profiles/archive/refs/tags/v1.4.326.tar.gz"
  sha256 "f7de5da64478c4b26f586302198d714508bfb84b23d0a4fb78fff8ad3bcaa5f6"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Profiles.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b2f47521ed8d6bb0f760ba2ebb0e77e5da3a1cb1d5e80abc8f4f17bfb80d5c7"
    sha256 cellar: :any,                 arm64_sonoma:  "193d300fc5791da66a7a94f18266dc5cafba656e8d6d4f46370424cf4c3625f4"
    sha256 cellar: :any,                 arm64_ventura: "bc2bd84db62b80afc64cf8d4da30f373382df66d68a4afd0f70787456ff8c2a5"
    sha256 cellar: :any,                 sonoma:        "4f699181074fba2674c045d940f1c86c2db3158887cd731fc4fba5b6ab7e66c2"
    sha256 cellar: :any,                 ventura:       "136481e5b164a3ee1998aaca04a561b4355d64ddea997e449575d2a4ffa85402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7c82ce84109308175861ce2c391d6691f4adcddbc2f04336941e3ec3343c712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa1615f62db8bb829459f95ece365850af3775683121512d71055ee2a3f68255"
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