class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.10.2.tar.gz"
  sha256 "2e52c6152b750fc13248dcb5d55259474ced25e4b09fdc965ea310565c1cdf78"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "f240d2cb564bcc1bd148e07c32ed3eed487d0302b518f7966f38a51bbec7f5a5"
    sha256 arm64_ventura:  "ac27cbcff6f80d4befb8a2bb584be3ed6fd85bc37b5792e26cfc90a9cdc6cbe2"
    sha256 arm64_monterey: "6ea0ab5b87b5b8654d805161350103e00b446c7e1789c0cfbb1519e72a448def"
    sha256 sonoma:         "78a797101159db75c2c1e2ffce42c035a2f354aa5369048081b0efa7b16b7c9a"
    sha256 ventura:        "7a1abf5232772aa462684a829fd6727a38ee208945565e862ef058f1090731ef"
    sha256 monterey:       "bd54fbbe1987c5b98b2c721067346baa58ea796388be804920f9114c454459db"
    sha256 x86_64_linux:   "d24422b91fdb00f5c300d30ab872ec221d57962784b06c2cc8c544e7a1cb586e"
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