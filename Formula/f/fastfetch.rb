class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.13.2.tar.gz"
  sha256 "69ff73a2f5da269bdfbde0a81182a427c6d141633a70cb4b69f7ad37e49726ba"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "828d6180cb7e975887948dce01a542455b9e81ee6be51017fc334905d389ee89"
    sha256 arm64_ventura:  "9b0a229b3a73d16cb5aff9a83053d2cbc82d318bb3943610c2144e124a90508c"
    sha256 arm64_monterey: "9c61a9389782fc38bf734e9559a32d4c995fd6bc3f790ad47ac2eaa47539d6b3"
    sha256 sonoma:         "a7f1b7a566185e7cd3f411eae595d22ebe469143f6076d148c43af58395db54c"
    sha256 ventura:        "37986595bea7809cf5ac629d98644081f7ed6f0725a18b887507604f091440f2"
    sha256 monterey:       "e892bfca0fc1c3bb3c4581c6f3550c0c56ee009807a8ab2e696ae5d6de5c62d5"
    sha256 x86_64_linux:   "b3e31bba6e20f9e4b9869c9cec15d84a3d67cac23a6ff4aa65703d3b6d712373"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pciutils" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share"bash-completioncompletionsfastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}fastfetch --version")
    assert_match "OS", shell_output("#{bin}fastfetch --structure OS --pipe")
  end
end