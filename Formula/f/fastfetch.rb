class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.31.0.tar.gz"
  sha256 "3036e34acc1355bf39619df1a2400f5f8316d188088f07d9a366a521bb30ad61"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "141a4b1fe7a3093746c5658ec88a21f06a276ba1d9ca6feb217e16fece8222bb"
    sha256 arm64_sonoma:  "08244cdbd55e3b5fd4c936dcc15ee1530d2c4ca2ff77125374944cae558d7359"
    sha256 arm64_ventura: "dbb3c7e105aa963e3c82e7e1000cb422baf8767b700f87803218f7ae8a6308e4"
    sha256 sonoma:        "495a9880150b50bbe3709330a000dd177a5c8c562ef8571c2836777d139606ac"
    sha256 ventura:       "ceba695f945ddeb8c9b6e6f3b929262d8702c963a98a8e788a7b804c20e30d3a"
    sha256 x86_64_linux:  "8330a376ab0f24ae1a9566158a5925a77e584bea2b463ddc6f148ab52a7e04d5"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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