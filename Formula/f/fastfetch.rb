class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.2.3.tar.gz"
  sha256 "dda15a6a73b8e6983d808d3f82567a0e8a333a3fdb53921d88a8bb2d65a38f32"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "62439282264ff01a9a656df54b77328e54ed8e3064ea9b103ff0aec8d3dc694c"
    sha256 arm64_monterey: "26f7a7a2dfc0b87258ce4fc187bba562a01cb809096304502ff7580dba4c94f1"
    sha256 ventura:        "9ce4e947893dca95933398d3a350ce8a6ce1c3304bc36e888295bd23daf77a01"
    sha256 monterey:       "c19bded58f9868793221245dc7926eafe34813562349aad7dcdfccfa17ed8a80"
    sha256 x86_64_linux:   "0752b7ab94e087b83e9044ebdac32aae600e175740d1a03d576ef6baa58f72d3"
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
    depends_on "pciutils" => :build
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