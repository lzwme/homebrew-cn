class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.49.0.tar.gz"
  sha256 "5c656581c6cb3061cf8648e2cd0cdf07abcf5f680fdc8bda935deece90b086a0"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "c5be16dc6f8ac8fa67638b71ed5bcfb598ccca693772a32d084de4443a286ffc"
    sha256 arm64_sonoma:  "74298a9c3129335ff6320e4528f661ca4a49e3c29ca52156ba68bf88edcc927b"
    sha256 arm64_ventura: "245bf04aa79992ac3098a501993043ed50a4280f5bf0c0eaa5363d0873bd1dbd"
    sha256 sonoma:        "5a0fd33bc756b900d148484c03d07579fa49bb5de59f9690cad4536dec034dcb"
    sha256 ventura:       "a0d4fc636a860a88fea69738f3e27233f403c93ce4d9001b4bd3c7970d32c75a"
    sha256 arm64_linux:   "badc74c73461deab9b7afaf76d6969961417969af0633e819c70dc99cfef57e1"
    sha256 x86_64_linux:  "91693527b618e30092a7ba9d5dd2e4dbcd02f20910d8569cc6fdda81ba232aeb"
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