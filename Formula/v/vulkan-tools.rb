class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https:github.comKhronosGroupVulkan-Tools"
  url "https:github.comKhronosGroupVulkan-Toolsarchiverefstagsv1.3.274.tar.gz"
  sha256 "7d54f5e0ad09a710e5781dcea8dc8dfde059301af1e7e4623d3a384de9b9aa76"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2c5b1a464503a2514977bd897bad5a3655ff27f7909d0ee50c7f30f9695c1f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24335e1247ef2e55e2bd53cd975d9c0c493caee9b7655e0a18f235332dca3d0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac671cf404ae2f8295bfbe25db3b413044daf10b809b9581736d7ab9e9b9a754"
    sha256 cellar: :any_skip_relocation, sonoma:         "334c634c1431af66c7ac9f193667be8a32c75de251adbfd295f8c92ad49c207c"
    sha256 cellar: :any_skip_relocation, ventura:        "e6a60022b26f510fb8b3d537df5e2c8bd8549ca36d0530884c7454e6b9630212"
    sha256 cellar: :any_skip_relocation, monterey:       "55da7e8df2203a0c404ccc702bd69618795be108b9d36499f1ff789db8a25ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b10fc3f32d441aacf51f799d88753b917c31d28449a708559c455fad539b44d"
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