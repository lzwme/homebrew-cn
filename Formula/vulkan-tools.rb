class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https://github.com/KhronosGroup/Vulkan-Tools"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Tools/archive/refs/tags/v1.3.248.tar.gz"
  sha256 "9f06f13e588034e323df9222532b76518ace8bf5e4eb4ca9fbc6960addf03a93"
  license "Apache-2.0"
  revision 1
  head "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d43b478e682c8460e81453ff75f3eac300058c3d19ba2e1f4d6e2750da7ed3e9"
    sha256 cellar: :any,                 arm64_monterey: "0119f3e62239dfa4f8509929b363b6f8204c036851bf0d815cadf12f428433da"
    sha256 cellar: :any,                 arm64_big_sur:  "d22fa20121d37a522bd03b1c988b93f1c745a804a5ad02e940d03aafbf91adaa"
    sha256 cellar: :any,                 ventura:        "a45909121d9f11880fb2209c95b1801f3c212d576baf5b099ccbdc24954db3d4"
    sha256 cellar: :any,                 monterey:       "5b1e7152afa7562baf12f65f47b7c8d24e25ca5baf227787a8859790bdd6f3ba"
    sha256 cellar: :any,                 big_sur:        "511ecabb8928e0e5f4ca349207ed4cf67a3a1d25f691fa5c9711beab888979a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a5d2c73db02f27f0be288bbc5b2504c1247e4eb07d18e202403acf6a66893e9"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "glslang"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  def install
    if OS.mac?
      # account for using already-built MoltenVK instead of the source repo
      inreplace "mac_common.cmake",
                "${MOLTENVK_DIR}/MoltenVK/icd/MoltenVK_icd.json",
                "${MOLTENVK_DIR}/share/vulkan/icd.d/MoltenVK_icd.json"
      inreplace buildpath.glob("*/macOS/*/*.cmake") do |s|
        s.gsub! "${MOLTENVK_DIR}/MoltenVK/include",
                "${MOLTENVK_DIR}/include"
        s.gsub! "${MOLTENVK_DIR}/MoltenVK/dylib/macOS/libMoltenVK.dylib",
                "${MOLTENVK_DIR}/lib/libMoltenVK.dylib"
      end
    end

    args = [
      "-DBUILD_ICD=ON",
      "-DBUILD_CUBE=ON",
      "-DBUILD_VULKANINFO=ON",
      "-DINSTALL_ICD=OFF", # we will manually place it in a nonconflicting location
      "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].opt_prefix}",
      "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].opt_prefix}",
      "-DVULKAN_LOADER_INSTALL_DIR=#{Formula["vulkan-loader"].opt_prefix}",
    ]
    args += if OS.mac?
      ["-DMOLTENVK_REPO_ROOT=#{Formula["molten-vk"].opt_prefix}"]
    else
      [
        "-DBUILD_WSI_DIRECTFB_SUPPORT=OFF",
        "-DBUILD_WSI_WAYLAND_SUPPORT=ON",
        "-DBUILD_WSI_XCB_SUPPORT=ON",
        "-DBUILD_WSI_XLIB_SUPPORT=ON",
      ]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "VulkanTools_generated_source"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (lib/"mock_icd").install (buildpath/"build/icd/VkICD_mock_icd.json").realpath,
                             shared_library("build/icd/libVkICD_mock_icd")

    return unless OS.mac?

    targets = [
      Formula["molten-vk"].opt_lib/shared_library("libMoltenVK"),
      Formula["vulkan-loader"].opt_lib/shared_library("libvulkan", Formula["vulkan-loader"].version),
    ]
    prefix.glob("cube/*.app/Contents/Frameworks").each do |framework_dir|
      ln_sf targets, framework_dir, verbose: true
    end

    bin.install prefix/"vulkaninfo/vulkaninfo"
    (bin/"vkcube").write_env_script "/usr/bin/open", "-a #{prefix}/cube/vkcube.app", {}
    (bin/"vkcubepp").write_env_script "/usr/bin/open", "-a #{prefix}/cube/vkcubepp.app", {}
  end

  def caveats
    <<~EOS
      The mock ICD files have been installed in
        #{opt_lib}/mock_icd
      You can use them with the Vulkan Loader by setting
        export VK_ICD_FILENAMES=#{opt_lib}/mock_icd/VkICD_mock_icd.json
    EOS
  end

  test do
    ENV["VK_ICD_FILENAMES"] = lib/"mock_icd/VkICD_mock_icd.json"
    system bin/"vulkaninfo", "--summary"
  end
end