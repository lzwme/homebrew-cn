class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.8.2.tar.gz"
  sha256 "7601f9f5c96b76913b6eb4397c9c2a56bf9ad998f0306b7f3ff335d1bf308db9"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "b1b99ad1c199a1019817c74df0b9c1b17045aec3333946c0c13c3605ffce74c9"
    sha256 arm64_ventura:  "c1389a0479c077a9c43c557149acbe6580c77d5b45ffdfad96fc9a3fc5c53581"
    sha256 arm64_monterey: "aa005e6076537a1ac13aa380d9f46dcc2fa7ac82a6c3a4f2142cc694647dbd7b"
    sha256 sonoma:         "5e8b7e95f381e1024ef007e1fd4471dfc9ac1ccef436d2f3051137b3efd5d33f"
    sha256 ventura:        "9d6d48f6ee95a5dc5c6cfc2251e81656a7865cf8dca643393ee0535d275a87b8"
    sha256 monterey:       "7c2a5cc4723bd25051ac6cad1ea87abbdce6d11816371ce086ad1fa219b10530"
    sha256 x86_64_linux:   "00938659be89e3ce00f057bc5744d5124b8e584e24f052bc3b2799f273a786f0"
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