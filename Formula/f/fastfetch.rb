class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.23.0.tar.gz"
  sha256 "3c92dd2cb15faf55d87846eda8d14456af2d0e0938998434144074c695c57529"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "72bb9a6eb75ccdcb4ce98e55098a33d4115e208bc7b3c493009091276591a942"
    sha256 arm64_ventura:  "44ec9eb663a95d0f7a3e20ac7e7fe4e85e40ed3992d33ce426f5d7fb235b0da4"
    sha256 arm64_monterey: "a3dc3e3b64250c505b71676bd7c8f28ebe38cb86df718bbeb000a2c8e32337f4"
    sha256 sonoma:         "2d079004e4bf004f0c13084bfef48d002ea7fc287e08413375afe90e7fed8377"
    sha256 ventura:        "626ca3bc02f3e02973b9fc33c70b0606774a0d4ea63aaed93301c4705f10c010"
    sha256 monterey:       "7559643d626beae9c9c15cd42268a88bfc4dcb368d79bb9e59a67b0af24df43e"
    sha256 x86_64_linux:   "e12c607cfa80796d831fb9113976baeb4eaddc3fb59dfce8cd44495e7b4127a3"
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
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
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