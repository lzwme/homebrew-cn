class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.51.1.tar.gz"
  sha256 "38755082ff0f7123616b98de5f032de76d0cc5837b5204cf5c88ee6c52a77bf6"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256               arm64_sequoia: "18a95eccf9146536ea498e8e127f3e545f13217bf1776ea16eb12f0518d321e8"
    sha256               arm64_sonoma:  "38f30754769e916e9cf23e819b5de2c310d99f9f08738dfbf086f34a24dc49dd"
    sha256               arm64_ventura: "637b4d0941d7a8b1b475cd09fedd6e7dfa8d92b1bcace2577ec9554663e382bc"
    sha256 cellar: :any, sonoma:        "d6ac9cd545c3bf750804894b3aaca4f76bbc859601dafb0ed2f191dcdf7b8e35"
    sha256 cellar: :any, ventura:       "4932e5696f10c639bbd3438a8d47861bccfee34e3e157ebe1622e66300ad1a35"
    sha256               arm64_linux:   "5fe4a7d41234c2bfb4f6184734b11d3427632d5efb5574ceda8b08dccab601ad"
    sha256               x86_64_linux:  "184879eefddfa66bbde806a04708c7e92482a31051d6d069ca534eb34057eb6b"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

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
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DDBUILD_FLASHFETCH=OFF
      -DENABLE_SYSTEM_YYJSON=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end