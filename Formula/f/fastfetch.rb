class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.7.0.tar.gz"
  sha256 "fa64838f7107bbcffecc303e94bf587a5cddc1082d3f83e13d3f5fc97b93250d"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "4566ab3199056760176ffdc6c3c67515618365db364878cc4b41da3c03e133cd"
    sha256 arm64_ventura:  "6094850c14a6ce387c5392a84e286e58d6f60e3d119b94f32f0d3eb297c8019f"
    sha256 arm64_monterey: "be325a483d1ccc4337fb3209bec18bd8a3d105a292b4880b6b0a07248245c822"
    sha256 sonoma:         "86eec5d6123f491f69c02301b81a244d3554bf5e067a33a229ec238bc1a229fa"
    sha256 ventura:        "3cfe769e189f075d009d8eb37dd7a5c2375774c3c5e9563c159ad2b367d950c3"
    sha256 monterey:       "d04fd8f4052f34c5df4cccf307f7e0bff417eea232147e73b5002e319bf7a14a"
    sha256 x86_64_linux:   "4756b2967cc047c6b2b1c86ce0fa8a1215ea633a6b8672ccd872cc2cc8d1014f"
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