class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.24.0.tar.gz"
  sha256 "675ac3f9dbe00277416744fa36a28fc9cd1284d17f055a4db339063bfc6a8209"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "2bd8421b7c4d9f9bb7b2e3942496387829bcf80a161643d40874f94e0cfa3361"
    sha256 arm64_ventura:  "4cbdaba6a8d45f93c591ed9419f8a60331cfda9220c93e19f0788c74cfa8bded"
    sha256 arm64_monterey: "0353d391b627a1175edc73067d598660a1cc9d55848f5da52f176754a23fffda"
    sha256 sonoma:         "6bc3a5c8e6a35424f7c1fb0bdec2940ca256dab8192f8c314b487c3b95da5c7c"
    sha256 ventura:        "3aeba97a1ab0d994802a21de29947d1f1dbf8f654aaaa969a6d6ded699b2eae8"
    sha256 monterey:       "e735f10452fce2ca0203b17a4c95de554c3f1754e76d5cf8999c0e80067528f0"
    sha256 x86_64_linux:   "dda7f48adad261ea681cd85e4602fe9cc3f8eb68430a389adf8840b52972a5f3"
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