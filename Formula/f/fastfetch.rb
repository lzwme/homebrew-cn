class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.1.2.tar.gz"
  sha256 "62b02c7e48cb328c4381e7d4af4b23a7c74a2879eeea53525b8c45cc0e79e65f"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "bd189ca57b44ba87ac06df473e0c98785c5f4edc8a1254d922473af88ca8dfc9"
    sha256 arm64_monterey: "afcd666ca0461f9bcee7cc0e24bc89a43993003f6274495a015204ace0e0f7de"
    sha256 ventura:        "c8bad3c2dcb88e22bce9adc58a1283d47693344c61fdb4668cb67618c6485fc1"
    sha256 monterey:       "0196542deb225fa9ab34cf71ea902a26cebf7a52f6287b3c644247ffdef349f7"
    sha256 x86_64_linux:   "d39f42b0374c789449107ed223974bf6f4dcd822fd64b805e30de6ba28350bf2"
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