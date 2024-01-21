class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.6.1.tar.gz"
  sha256 "4d3b9492c7bf9ae7a2436803220e5f4d8204d3f9e03de1d80f841faf2ad7df5d"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "1cdfa7213929fb443a64411507097ff1e4f901d85aa37eaf4beb2b34eefa8a10"
    sha256 arm64_ventura:  "e87914ed0bc358656da2491d280346c4bd720f04b4fde2f3212413a352d22feb"
    sha256 arm64_monterey: "483c2c5e4ee65d7d40b4d51e3c7029181e8ce9b7fe6d2f3b008d7ed2c27c9a13"
    sha256 sonoma:         "8472a8c831de88485dbdbfc300e9e5cab3c12c5502a2cc58a76167f6d80588ad"
    sha256 ventura:        "b8db0ed2458de3dc321b0a13c9657c1aece623836a36621d53691d2fcb9058a2"
    sha256 monterey:       "fda9d3b7809967630658f26f213570797351efa28eb7115be314d627685bf56a"
    sha256 x86_64_linux:   "da444201284dc133221351ded62debc580d777b639dc99f470a46b622b5506bc"
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