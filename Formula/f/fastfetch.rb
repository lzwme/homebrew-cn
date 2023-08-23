class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.0.2.tar.gz"
  sha256 "6fcf020c855bd4ad97e9bfc65495b829d9754a94b84df3fadb32956d1f8f2938"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "06a1cf556f03a043fb294378eed1c968984c7d2d8e85210371abd0f5329f8601"
    sha256 arm64_monterey: "c6ebd996f6f786ea1d4c01ed625c5be1174a9a6d79fd167612c63181ae74fe4b"
    sha256 arm64_big_sur:  "307a5e46334afe1693375289fd39df13d7afb466ed44c9b29c337ebcaaa59914"
    sha256 ventura:        "439c9a89032980a0d62f067431e3669bed409b48968a98f7419ce92366004da9"
    sha256 monterey:       "c72a737f8ef6f2ee7f870da2dcc2d1c1e358c589a38753b9cde47c0354a5c981"
    sha256 big_sur:        "c436f8bc19beeeaade845c5c4006cfeb55c3fd11d87644c2669f02b917ca6ca8"
    sha256 x86_64_linux:   "08fb871eb235340e07403f474725526c4b4ba9481ee0ab4d2bc994184e58b322"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
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
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end