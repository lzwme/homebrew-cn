class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.11.1.tar.gz"
  sha256 "ea0d5e3652c78b7cebb7c370d2e6732edfed4d5dda6e8e06c02a1f0216cabe2e"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "906ecbda3311512af22d2e5f142839b3e642fe40551f4b676c601c837d88f4b9"
    sha256 arm64_ventura:  "195eb1c3460c67acddb2a6c8bc7beca2d07917757d84fa3b12acae0e2db14b3d"
    sha256 arm64_monterey: "f89791853105e62c4f122feb8211811b02c6aea1032299d596353817f6d84534"
    sha256 sonoma:         "5dec0934b57452934b3fa3b5c64d22f9f0f12f27cf246dd5a8d271b781b39c6b"
    sha256 ventura:        "41e7c25d00559591a8d56745e3fd085dbf135f7c1921d3472dd92e6a487ec60f"
    sha256 monterey:       "abe67cfb1915ca4826522d0c7374279e0f5d9fb91e308eb13504ea6a8603fe5e"
    sha256 x86_64_linux:   "129c2c5dd7fa8f7e7b0aca5b21f7767964916bfbe318bcc3ac4747055a794ba8"
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