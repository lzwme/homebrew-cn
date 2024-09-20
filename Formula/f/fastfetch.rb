class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.25.0.tar.gz"
  sha256 "17ea39fd062d5bccc9c608e868f593a665d569646bc9b447111b3a608b648783"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "7d8d3f2220b3af9819676c3d6c257054f3cff7e39c156c6062d45d5c55b0aaba"
    sha256 arm64_sonoma:  "68fdf83574ce246ac6999b6cf7de910ca8c6f249bcfd55467781e04f70b8a7dd"
    sha256 arm64_ventura: "81752be50641b8722536f77464ba30cbd86237e52eaed923a1e021464500c5f8"
    sha256 sonoma:        "f3bdffec4c996bde60c57593a7d064fe036343d34db64930ff0f9e4ba73f871e"
    sha256 ventura:       "c9e20f1b4260447db0fdcf83c8d784b52cdc16ad50750a484497ba092817191d"
    sha256 x86_64_linux:  "611ebb13044819491cddfbc16c794c4754bdd88d73239376ec27d1fb43293abf"
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