class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https:github.comKhronosGroupVulkan-Tools"
  license "Apache-2.0"
  head "https:github.comKhronosGroupVulkan-Tools.git", branch: "main"

  stable do
    url "https:github.comKhronosGroupVulkan-Toolsarchiverefstagsv1.4.310.tar.gz"
    sha256 "304c3f6c3395186a6559078f3b174de58b467a5b5a3254bf2f1a6fecd833bcfb"

    # patch to support support for iOS and Metal surfaces
    patch do
      url "https:github.comKhronosGroupVulkan-Toolscommit42c54538e6c165adbc4492e89188066c68c14542.patch?full_index=1"
      sha256 "b2dcfd6046f6848c33e22ed57049718c704f2186838b2f6ceee80bcae18fd558"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e1e08deb022a82dec0ad4d9974290eabaddac76cf3b8cafa946b886c30bcff16"
    sha256 cellar: :any, arm64_sonoma:  "b88463b1bec7f0e1667a6c6e0aa033846fc5df5e89a68229bc96015fb51326bc"
    sha256 cellar: :any, arm64_ventura: "0ebb2a9e369a8f3c54231a539134a13541e8f4714e5b64d6404fb7669ead7db9"
    sha256 cellar: :any, sonoma:        "08569572e842bb312bc1c961b4ad8b5a238ea2dc6419f5bea6571e0dcbbe6769"
    sha256 cellar: :any, ventura:       "38247a40071f92852287e424db5f4cc578f18349a5dcfeddfad563ac77adf17c"
    sha256               arm64_linux:   "bea441877553646d0bb258a29830fc930869094a98e5163ab6f6d5585c981086"
    sha256               x86_64_linux:  "9bf51a09e52537a6a739342b288ba9aea66cac390cc97d166dcf22fd05b3c625"
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