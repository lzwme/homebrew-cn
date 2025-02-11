class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https:github.comKhronosGroupVulkan-Tools"
  url "https:github.comKhronosGroupVulkan-Toolsarchiverefstagsv1.4.307.tar.gz"
  sha256 "4f0baeaf078c2a9d298b87d6d6ef85c3faf08f0f95b8a7d7d7ff243c6de2707c"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "502e60bb048d10eeba3665bdbf4668279cadfde780048397297be9a81d4557ad"
    sha256 cellar: :any, arm64_sonoma:  "53e0852f35fadafcda2af7f5b01c2011fff132493f634e3a724564a5e0fe8844"
    sha256 cellar: :any, arm64_ventura: "9e841e656c68b080846623e2cf491ee950b5487ee6cb49359957b4bce3a41299"
    sha256 cellar: :any, sonoma:        "f709728ab078f21dc442530b54cd12b5973a8ff40fd495dceaa3b57b1b38ab0e"
    sha256 cellar: :any, ventura:       "6cb7b4bc120b9917a5fec6f94550b29e0e6a88443964e41e9e689bbc2fc1322e"
    sha256               x86_64_linux:  "89c318bc51a7fff24370640fba6d4d86de27a0ef17d5ba6998597f3577712be5"
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