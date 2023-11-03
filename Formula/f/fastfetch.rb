class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.2.1.tar.gz"
  sha256 "62d6cbf2e354c7137c980b0637634fd085da91af11acf8a811f21a88318f04db"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "0b45560ea1c8d44e7de59b338062844adea78f54afe2a5db29a8a866a1018dc6"
    sha256 arm64_monterey: "4a000aab7da286bf8aea588a1081846b31a3f2435abc05ce752567c7eea58e5a"
    sha256 ventura:        "b6b6460fbaa4f5e4bfbdc9c40bf919ab10ffff1a6013db62bf87b81f960c3b5e"
    sha256 monterey:       "47e031b61d6f363a68194068068d969d10a04d0c654b8246efb1c5e5df0c802f"
    sha256 x86_64_linux:   "16999a7975bbd6778b01dde48c65f4d237e34b1943d025b1d7dc2105024a60b4"
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