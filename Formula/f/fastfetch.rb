class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.9.0.tar.gz"
  sha256 "ae0b0d0bf4d4569fb5dff6b1d67bc8d2091ed4a9aec6ab43c2c73430dff1f9dc"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "057c5d3e1c3220ad940950427c8ff602dd6c846f064eb0f17f9f35677bb4c8da"
    sha256 arm64_ventura:  "f5d9f7e1c7d1408a398138e8f4f253b3436e3b2d5cda5fbb6a49b7dd4cd16d06"
    sha256 arm64_monterey: "4773432352e056cf75219649c72036a8d7813b262355d57606e015218fb4c6e6"
    sha256 sonoma:         "290b682baec8d2eeabd3dadc0c5a7e49c97da40cb07e3951d4fca8f61d0f87fd"
    sha256 ventura:        "2b5d74f7175c408ef1e06b83bb3db0342227f90bdf1aadffe0fe19bcb7859e64"
    sha256 monterey:       "1665f405fa27c88aab0757e09957248f8d8690b0d98f76014fbfc6577ae9be69"
    sha256 x86_64_linux:   "fae4444d3799fccfdd19431ad13bbf78752ffa6a6aa0ee8e858dad2461a2bed7"
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