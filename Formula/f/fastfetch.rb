class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.17.0.tar.gz"
  sha256 "b108ecff62f4e834f639da8f24d332af7901376e3ace97ebfc6ec81114315556"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "41e23b2ab39a13fd31aea069a7d8cad4f65aa9ea90f4c62d501f04bb4c4afd6d"
    sha256 arm64_ventura:  "b17dab4c2e578fa0390f8e5927e274004018cf79b9b9d4e71a7cc359907fb1bc"
    sha256 arm64_monterey: "8518d10dd75ce58a5992f6ba9ac2db462ea7d8a77c6b6f999687dd5e69951b94"
    sha256 sonoma:         "71e6733f1bd9dac31bf1faee895133f525e1ebd504f4211177693b2b620db99f"
    sha256 ventura:        "67752aa085af264e2ff1a601d5e199f3d3931a8ccee309ca0e57227afcf430d9"
    sha256 monterey:       "0f1bbd359f10de9b5d717c8188ff6b70239152fa4d93e1a70565e1a154878121"
    sha256 x86_64_linux:   "ebb9e7186d55f836b2ff3f8ca5883f957b08409450abd90756dba0622d54116a"
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