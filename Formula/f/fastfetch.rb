class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.7.1.tar.gz"
  sha256 "64778068628426a1d4394f756cec70a62dd9f7fabc267dd7bdcbfc6302f6476e"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "9f52a6538debd0dd7d47b378f27920190baf275ba1125a2955eead105fbd1373"
    sha256 arm64_ventura:  "695e8021e665b05490c0eb8fcabc64255cad8b6cc0dfecf42d0f3d310a5d1f27"
    sha256 arm64_monterey: "3a7bcd8f44cee07d2935e0ab61f241aab169cf3155bc48e9c3b6c467103ca80c"
    sha256 sonoma:         "416a4ac941f7bcc0cc7c2a97068560a34d2089dfb1d2c13e4a7b15f2122c00a6"
    sha256 ventura:        "996ed98e4d70bc1ef00b553feaee6b150071bb61e4d2c37dee7527d3ff962f5b"
    sha256 monterey:       "24ff7f0be16db7fd0d490c556544fbb4f73b23f6da02ff8cded9ed17db827631"
    sha256 x86_64_linux:   "bdd99f373889a9da6a0826a595ba24fa1972b38b1c25e4d53b1d74aaa0401040"
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