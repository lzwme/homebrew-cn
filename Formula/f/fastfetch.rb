class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.18.0.tar.gz"
  sha256 "7635b46941c774f0faeee904c36a33a5eef1e5aa959a73ad1a30efb23dcbf50a"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "86bfbac1e214366532e417aec927d4d0ad20c0dd01958c0df504424d4d73878e"
    sha256 arm64_ventura:  "2b8a0c2a44ebd397ab0ab994abae6d08ce8785c2cc1751f4ded17ac74630e354"
    sha256 arm64_monterey: "0caa8adc1d7dc9e03bbc96eb8bb35d85eb28ca2080b22b224d06abeb9aa9e566"
    sha256 sonoma:         "9087a5c5de30322bcfa5e777a8c81a173437b2a895e4bdba392daa476bd5d2e0"
    sha256 ventura:        "9971f3217224078a9316d3a599c1bb9edbf263eafd4e527874981794e53f7163"
    sha256 monterey:       "e72a8a9616feb19ca9793b009e8301dded93415a3fead10b7a041a5cd0668121"
    sha256 x86_64_linux:   "4fef3638bac9a24b2d1f649b81baf4cde13f5e263a7e7bf11986438185bd7e93"
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