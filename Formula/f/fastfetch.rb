class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.28.0.tar.gz"
  sha256 "115d9947ee0acf6246894888998db31de024f651123396c6251033390c241dc7"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "e8cf93544e1e99a6e6992b1a0fb04f5b09a9033c2efb8264734e2bc634ffc5a1"
    sha256 arm64_sonoma:  "408d8983c1ab8c6f3c0a84c0a093ea8553707b2d3fcf78bea78cce59b6b35166"
    sha256 arm64_ventura: "f89307d813db4161bf443f9541dec106809353de473bf997aff72aa31ed549ac"
    sha256 sonoma:        "a4eacb23c803ba84a7a91f29b151457e742fd62a94bdac83eb1e4ba152721ff3"
    sha256 ventura:       "61bb2dd58c9fafbf245e7cbef3ce4b1b4f97aeee0cb267a606ffefe58204d499"
    sha256 x86_64_linux:  "50e845771e5c21bdcab9660c146d2d3ff1d19978bcbb10bfb8bb4cdc261791ed"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
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