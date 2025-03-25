class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https:github.comKhronosGroupVulkan-Tools"
  url "https:github.comKhronosGroupVulkan-Toolsarchiverefstagsv1.4.311.tar.gz"
  sha256 "7113bc0c746b45072e269fada0d684b4ae9de609c38d9e764b59793b14120a7b"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Tools.git", branch: "main"
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6458828c665ac5979e243bb3e9ce64ed1ca9d603c73381f937e9d100fb076fb3"
    sha256 cellar: :any, arm64_sonoma:  "fd861e5b6e38adac91fdd7610100475a17070012acb62c5f6809bec214006bae"
    sha256 cellar: :any, arm64_ventura: "27d6d9c2391c82ce8bbfa869d4c7d03c1e23802f50447795cee8a2b8788757e6"
    sha256 cellar: :any, sonoma:        "c13f274d98eecc699487a415aac33da49cbe1ba506c9d875e8d5a9e3ce3201ae"
    sha256 cellar: :any, ventura:       "c121d2c91772dc43b7455c79f7153d46a0f4f3d0b29aae9488db176e1098f51b"
    sha256               arm64_linux:   "f1d78d7f8b9c10ccfdff74ab4eac2b1bbcd3f893cc5eb43a232c112248633c2c"
    sha256               x86_64_linux:  "e968bac16776a6cf96ea9043ace2e4d3aa55a18de736783396a0ba7d51242723"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-volk" => :build
  depends_on "glslang"
  depends_on "vulkan-headers"
  depends_on "vulkan-loader"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "pkgconf" => :build
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
                "${MOLTENVK_DIR}etcvulkanicd.dMoltenVK_icd.json"
      inreplace buildpath.glob("*macOS*CMakeLists.txt"),
                "${MOLTENVK_DIR}PackageReleaseMoltenVKdynamicdylibmacOSlibMoltenVK.dylib",
                "${MOLTENVK_DIR}liblibMoltenVK.dylib"
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
    with_env(VK_ICD_FILENAMES: lib"mock_icdVkICD_mock_icd.json") do
      assert_match "Vulkan Mock Device", shell_output("#{bin}vulkaninfo --summary")
    end

    return if !OS.mac? || (Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"])

    with_env(XDG_DATA_DIRS: testpath) do
      assert_match "DRIVER_ID_MOLTENVK", shell_output("#{bin}vulkaninfo --summary")
    end
  end
end