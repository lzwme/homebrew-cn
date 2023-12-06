class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.3.1.tar.gz"
  sha256 "0d883f27aff597c348929d1d7ea640616f18bd20e3e57b3db7194f5207c4bebc"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "0c46c2cc1befbf6d70d21d90ca20ccbb0676cdf068c9e29d4f2efd968decc10a"
    sha256 arm64_monterey: "25c77e9c60dbcedba5e8e056a148b4277df898eadcb4e3d9df9203ed2b18e2fa"
    sha256 ventura:        "347df3bf7f6d293b229039780ed6ff14420b172840aaec1d8645fa8f00ec2378"
    sha256 monterey:       "ae77fd0378f50b23c61a11534868e2cd58468bfd3a57f440d918b47dc4a6868c"
    sha256 x86_64_linux:   "08035784014735ab7680f631c26f2452b990fd6ea76380e1ec6e6dfed996783e"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
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
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end