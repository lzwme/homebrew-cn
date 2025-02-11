class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.36.0.tar.gz"
  sha256 "bdbe5c7672aeacfec15ec7539f718e666c5206b1a3de9bbf8bd1b3d3c9c997e7"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "6829c05994a5ebae3e5f3d92cea702a634ae3869ef5d4a5bb1691e7dd7ecc991"
    sha256 arm64_sonoma:  "ef26cd1cc16b39f52aa688199c646fabd150ec316a7568819c72c38ea25c43d1"
    sha256 arm64_ventura: "3d7d70a9d5da0b194d4361d173ff23eae64ee8cf5c1e7a5a9329db4b6556f7c6"
    sha256 sonoma:        "7407a4fd88b1c6e10f44fb98b43b88b51b3ea830aa14bdf13562556a2acecac1"
    sha256 ventura:       "b6e0b40d26effe066c40fe1a6efa7efb0e541c20c6cc591349c119368ebd18ae"
    sha256 x86_64_linux:  "58b8aff593abb67f414276a01721dbf564f0870aa12d2cc5298ce975539e5136"
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
    bash_completion.install share"bash-completioncompletionsfastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}fastfetch --version")
    assert_match "OS", shell_output("#{bin}fastfetch --structure OS --pipe")
  end
end