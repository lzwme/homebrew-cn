class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.8.6.tar.gz"
  sha256 "f21cb61227f9a72382f5ab21fc9ef8bd3b424514ea27bd48036b53e4c6ba33bc"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "417da72049ab8d5daf3e2f35d394bbb3e676c6ce1eea787deb301354377baf89"
    sha256 arm64_ventura:  "407183071d7bc93e4de25be4b97091d25838b38c2876e51b564c7a41e05c2946"
    sha256 arm64_monterey: "ef2f25b38686c51f1d2e9244ff0f3158a37fd27cae6f54db0836d11a5908e9ba"
    sha256 sonoma:         "ef61720acafdac33350ecfd22365478d1719dfcca512fd275d195165d0f9a999"
    sha256 ventura:        "79544790168d7e655a56c01c10cb022893c8b7d4672817e011ac429005fe98d3"
    sha256 monterey:       "7750e69bc57b9375fa3e08d348ab06be1db0d69be6e475b18f574e50639f6964"
    sha256 x86_64_linux:   "9ededa465f3428ff592e4d9128a9cb3f48dee14d9b72a2c0493dc3ccded27d2e"
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