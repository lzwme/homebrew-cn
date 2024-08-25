class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https:github.comKhronosGroupVulkan-Tools"
  url "https:github.comKhronosGroupVulkan-Toolsarchiverefstagsv1.3.294.tar.gz"
  sha256 "3eac1a3e4991b1c6ff92b29676f1291cf7fadd249cf6f142d5900af2e3179a51"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e49824226cdea830f244afb6651b0e1e5d7cb4461ed3afaa3c7327b7f8b2aca"
    sha256 cellar: :any,                 arm64_ventura:  "cf87d8bfb28a9aed028ac6d6fdecf9260a63349029519992d38af9089c30e45c"
    sha256 cellar: :any,                 arm64_monterey: "8f7e7e77d7baa9800fbf752a8eb7644e1bd19192f7111d743a90117540a7756a"
    sha256 cellar: :any,                 sonoma:         "ea769e305e35d01ef9e0dcd3139c16ad5832b2406d34287e15f9ae2848424822"
    sha256 cellar: :any,                 ventura:        "6576075ecdf12d77148899bbd6ddfb239bcd52566ccee47ca444b53917f9552e"
    sha256 cellar: :any,                 monterey:       "4e2862f0d316e3cc4b56417f389a8cc0f18c1404c38dc383d2a7ee8c4548c25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ab331eb582d4d5f6bbde13c1ca49bb8f48ade9b65f5e645e00605fc4cc4e67"
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
        s.gsub! "${MOLTENVK_DIR}PackageReleaseMoltenVKdynamicdylibmacOSlibMoltenVK.dylib",
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