class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.3.4.tar.gz"
  sha256 "d132775816685b7ceb8adc164af50a96814af879b97ad453efca3a285efd96d0"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "897a277742b7805318e23c5e8a653aca4ffc43721ff418628c1f51ffdfd42208"
    sha256 arm64_monterey: "15de227ae4d178d0896fc508a561a2f8ae477b99c3018c2087f382a4acd18e38"
    sha256 ventura:        "12f986faf6216cf957fa5689c249341a7d43ba8f1ec8f97bbc5740af4ad86319"
    sha256 monterey:       "5b0d20f413c393d4706240de37d9d17d2ef492bda4d60f06c6739cfff9f32d7a"
    sha256 x86_64_linux:   "3991fa80855e8b3f1d678adb996ccb48057923ee7ea7867ebd9fcb72e5feabaa"
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
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end