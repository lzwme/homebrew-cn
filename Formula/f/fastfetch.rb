class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.5.0.tar.gz"
  sha256 "f60345fd56744077a6f66209b89826c606fd8fecf05ec08f804269eda90f7aae"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "4b992f111bd8d01559ca6fb134c2499d0f1b94a9e70b08cfbaf1a6af2c200a18"
    sha256 arm64_ventura:  "389bedc5e958adda70b9cacf3250486e4252fec72e1bda9c750b1874e25f0f2d"
    sha256 arm64_monterey: "2716db5690b501dc130a0fb1758082b9febfd9ec54d36baaaee75e0c7251a765"
    sha256 sonoma:         "4f4e3ac43a5c075d59c81b3eff7b95242e245dfb432bec858e326f296ec2a342"
    sha256 ventura:        "23f9849d19b70cc5e11471ed97818f30926f7b67ea6dabdd9ff0902b819a54c9"
    sha256 monterey:       "0fa60f1360bc57c5d57d4dfa26d2848b821ee07762fe7f31a5ff16f3c04b275e"
    sha256 x86_64_linux:   "5dde0a458754bb75776e393ba8c7c4b7e64619af8f7fd76a7f31561616b6222a"
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