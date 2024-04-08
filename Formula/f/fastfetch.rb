class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.9.1.tar.gz"
  sha256 "f22bb197095ea80c4aa17e1d4b5e0dd6e79234f4a18f427691c7e6f93a812ac8"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "cfa60d00023573bbc1c5a9cc73baba9e1e428d0e538b7762c26865c5f0b08b0a"
    sha256 arm64_ventura:  "84fb18bf889b4f5d1339504b223eb6bbcb65069b1b7a236e1970e3e40e36d3dd"
    sha256 arm64_monterey: "91b856bf5d3928f7b02c4a3bf2d2307773fa502c6545f2bc563e9547509c8326"
    sha256 sonoma:         "db86e3c273dfb2987db0718e0f70e69c204da53e40c64c427b3ff1fc92a90496"
    sha256 ventura:        "8f68d2ec7f3ab2bb93b3d353e899426dadcffbd7773bddc409a3370c3e59d11e"
    sha256 monterey:       "66f94e3c1aa9c58e22025548694db5d22afbf6a59561a9685c1086c3fdf0e627"
    sha256 x86_64_linux:   "f808d3848a17a97c7fa1597f5493bf17dc8c211e9132edd406cfbedfbeb14bac"
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