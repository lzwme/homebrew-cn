class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.21.1.tar.gz"
  sha256 "67afc33bc1ad321cecf9e4c6f22b09d85020d0beacb10c31008d1111a6a72b70"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "e1ba310b05689561813e5c4ec3b17084c5a2efcff0bbe306bd6996a9a93b06ec"
    sha256 arm64_ventura:  "0a16222147cb729570fda780fe67fe1df2e7db270898b5854ca919b0f6c59afb"
    sha256 arm64_monterey: "b3a6a6e0ba931167c749e81d7a94535e0417a8fc6ed48aa120b30d3ff320a8f9"
    sha256 sonoma:         "ec64681b9f5fb8e7251cd046cc0cfb931877f000b1bd6f614e3b970a565fd69a"
    sha256 ventura:        "1c6e374c889be51e197d6cdc559670e006598d3230183fa91b205512450ed6ff"
    sha256 monterey:       "da951dff369b5429403cbc01182955149b35bab8ea0001760ad435547e97fa33"
    sha256 x86_64_linux:   "03e0557630f3737bccef089612c81d6b6f88a92464b8a95573001b3bb81362e5"
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