class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.48.1.tar.gz"
  sha256 "912692fb4ffa34b10809909e3a774e8193751554f77550d6ae126892b029c021"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "6008c8d25b0d316324cf1a5eed9add6ce1c41378bcad7f27d8092ec6d62af098"
    sha256 arm64_sonoma:  "dee524539759d2910a3d170bb016ff3ed8cc5f0b1e03ff2b0726fa6e7f18386f"
    sha256 arm64_ventura: "18dbbf60538d462e88688cc7b2733253bd33c4a8503d900b48b602983553121f"
    sha256 sonoma:        "a68fdf3c0908d7252d45fa9166d660d28679f61826182cd838aec65c13567246"
    sha256 ventura:       "b01266f5682420b30660d6344b81f15d5262fc6c7ace17f2270d28ab4a697520"
    sha256 arm64_linux:   "a4d26458cffcce3a351e4e2a8fdfcde3a1e4ab10fb23b7d94de31b47d6e32493"
    sha256 x86_64_linux:  "f2b44f11b826077efe6ff6f563a160b4d9af4bcfaf241f855a41da71544aeab4"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DDBUILD_FLASHFETCH=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end