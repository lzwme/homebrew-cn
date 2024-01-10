class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https:github.comKhronosGroupVulkan-Tools"
  url "https:github.comKhronosGroupVulkan-Toolsarchiverefstagsv1.3.275.tar.gz"
  sha256 "772ded1443ed5bfbb58a294654fdd72bb7b42336be59472e41ca3b32c0c34937"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Tools.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad2c7683550adecb7d60675da2c58546a4962e44adc7040ddb025d7a45e26490"
    sha256 cellar: :any,                 arm64_ventura:  "e0197b81ddf295fcf1018ca2b5d69b1d27ba86bae76302185ea5d401b16c62c1"
    sha256 cellar: :any,                 arm64_monterey: "2feb8082702ae818a0f5ccf9d69fdc45c3aace0979cd0200c4ad21fbe4fdcfb1"
    sha256 cellar: :any,                 sonoma:         "9adf3421c893ec73f5bf2c97b11e59ed0c1d04406cb67adbaa193f8f01d13f37"
    sha256 cellar: :any,                 ventura:        "5801efc8f857156dc368932f0d09858b4121dce63cd0c8c78eed51413faf911b"
    sha256 cellar: :any,                 monterey:       "0b987c845b2651ffbabef2b6a779241aac0dcd2ced75f193ade800fc83103591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048aea44176bbecb2053c561e40e93362b40d2045e12ef102fc9e6be975c4d17"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-volk" => :build
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
      inreplace "cubeCMakeLists.txt",
                "${MOLTENVK_DIR}MoltenVKicdMoltenVK_icd.json",
                "${MOLTENVK_DIR}sharevulkanicd.dMoltenVK_icd.json"
      inreplace buildpath.glob("*macOS*CMakeLists.txt") do |s|
        s.gsub! "${MOLTENVK_DIR}MoltenVKinclude",
                "${MOLTENVK_DIR}include"
        s.gsub! "${MOLTENVK_DIR}MoltenVKdylibmacOSlibMoltenVK.dylib",
                "${MOLTENVK_DIR}liblibMoltenVK.dylib"
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
      "-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["vulkan-loader"].opt_lib)}",
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

    (lib"mock_icd").install (buildpath"buildicdVkICD_mock_icd.json").realpath,
                             shared_library("buildicdlibVkICD_mock_icd")

    return unless OS.mac?

    targets = [
      Formula["molten-vk"].opt_libshared_library("libMoltenVK"),
      Formula["vulkan-loader"].opt_libshared_library("libvulkan", Formula["vulkan-loader"].version.to_s),
    ]
    prefix.glob("cube*.appContentsFrameworks").each do |framework_dir|
      ln_sf targets, framework_dir, verbose: true
    end

    (bin"vkcube").write_env_script "usrbinopen", "-a #{prefix}cubevkcube.app", {}
    (bin"vkcubepp").write_env_script "usrbinopen", "-a #{prefix}cubevkcubepp.app", {}
  end

  def caveats
    <<~EOS
      The mock ICD files have been installed in
        #{opt_lib}mock_icd
      You can use them with the Vulkan Loader by setting
        export VK_ICD_FILENAMES=#{opt_lib}mock_icdVkICD_mock_icd.json
    EOS
  end

  test do
    ENV["VK_ICD_FILENAMES"] = lib"mock_icdVkICD_mock_icd.json"
    system bin"vulkaninfo", "--summary"
  end
end