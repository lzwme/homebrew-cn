class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https://github.com/KhronosGroup/Vulkan-Tools"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Tools/archive/refs/tags/v1.3.267.tar.gz"
  sha256 "688f98736a2e02c6f9fcc7dc105046acf730c0fa374fe92ad1bc04bd92db70fd"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3abee46139eb3354653e203c263152dc778713e1c45fb13d0ab9c2a79185426a"
    sha256 cellar: :any,                 arm64_ventura:  "a26ae1afcd60726d63aee2c343d65e07edc1cb586a6b614592f660b44485af04"
    sha256 cellar: :any,                 arm64_monterey: "28d14001d0e42beaafbf53c76c1c33961d97221e221a9635d4b09124b3c683a9"
    sha256 cellar: :any,                 sonoma:         "cddb3e24bea079e7c12ea8a9fe0de1162ddc40a443c4c175076873de9ad1b950"
    sha256 cellar: :any,                 ventura:        "8a641f88233d61bf1f3f966cf99212575c62488544d19c562094ceba00937730"
    sha256 cellar: :any,                 monterey:       "f60e585d8d65c3074ca96a07b0e00d8d7060f679d2cf105a8f076a2a7c06b29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be58ef21037546d74f705bbad0e76da66fc4ac12dd16202092a26075f8f298cf"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
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
      "-DTOOLS_CODEGEN=ON", # custom codegen
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
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (lib/"mock_icd").install (buildpath/"build/icd/VkICD_mock_icd.json").realpath,
                             shared_library("build/icd/libVkICD_mock_icd")

    return unless OS.mac?

    targets = [
      Formula["molten-vk"].opt_lib/shared_library("libMoltenVK"),
      Formula["vulkan-loader"].opt_lib/shared_library("libvulkan", Formula["vulkan-loader"].version.to_s),
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