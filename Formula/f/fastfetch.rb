class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.13.0.tar.gz"
  sha256 "a86c8cb98341be0474fa0e8e847adaf201d78ae29340605064b14a12952bca35"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "fd3bce69b66b4b21653cfdc0e474080642cb36fe7a44291ddd94fd7a25ef74c2"
    sha256 arm64_ventura:  "5f2de86d13bea4bd3c840199a8545ac2c860cac7168199b7533ce8fa9d273b42"
    sha256 arm64_monterey: "669c1b3efd2ac4515f9602193be7d0a910cb6080d86332f9fc298a48d93f81e4"
    sha256 sonoma:         "58afb0a7ad279409a508ef1aeae4aedbc011bf7275689ea4ec5498340aa6de98"
    sha256 ventura:        "23f7c156dfda6acb1d4f668ee8336809dd688b689436a38f8961c28660139d97"
    sha256 monterey:       "b9793916aa4b972835fb3950492035b5e970149cdb040ad4851593cb9bc017ea"
    sha256 x86_64_linux:   "5de0407f4979306fa00bcfc60be4062d2da489c2e33d27aed839cdf39e597a32"
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