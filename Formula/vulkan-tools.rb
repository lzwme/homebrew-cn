class VulkanTools < Formula
  desc "Vulkan utilities and tools"
  homepage "https://github.com/KhronosGroup/Vulkan-Tools"
  url "https://ghproxy.com/https://github.com/KhronosGroup/Vulkan-Tools/archive/refs/tags/v1.3.260.tar.gz"
  sha256 "f071232eb52172b742aaa9ca66647140df98ea443d6591b54c6f850fc05990ac"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c955036797cdb0ecdb3177ec177a04ee5bc93c8e3fbe7555f4f4979c9fcda4f5"
    sha256 cellar: :any,                 arm64_monterey: "f57a55036587fdc4e9d553b57de6d88dbe1c3cf5c4326c9a1bd0d1793fc5f747"
    sha256 cellar: :any,                 arm64_big_sur:  "73dea8dcab962da81c93fab6318ad7d546a6c4a4dbf72ae0c7e1e0705279af4b"
    sha256 cellar: :any,                 ventura:        "f22f794ceeca8e6a722cfe786ed8b6ad5ce63f998412939885da1bc4716ca3ff"
    sha256 cellar: :any,                 monterey:       "eda5e74b385d74fd790491ac104bffa97686e7a317cf943fed83aed48a19420a"
    sha256 cellar: :any,                 big_sur:        "efad9ddbe9551f1d18f94671af76e17a112d4c0ef4f94fcb74da3433e30af856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f49ed6ee74427534223632efed5ac987938984df0ebd55467aa6c76b04ec2bba"
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