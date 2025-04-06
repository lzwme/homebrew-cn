class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.40.3.tar.gz"
  sha256 "e79984a4a6d233c6a2d1f5341e272580bcfb59de2b6e48b0d7631a3f65d4c1d2"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "54b662d0989bed7f46fd4c4d19e39e13af05ef73bc4123b8f9beb7a136564462"
    sha256 arm64_sonoma:  "22bf48fb4fd82fc70d01212d8501411296292daeeabeb6e7849664015bcf142a"
    sha256 arm64_ventura: "4b160eceb576c88dac6dca301bc232b5b7ad3daf825b27805161f8990ae5c525"
    sha256 sonoma:        "53d8e711bb4cb5c725ea6f6c020a70a85526b1df48c1f69788ffbca8a24b3f71"
    sha256 ventura:       "b71895d7828daa69b769bb9ab6648ab79f799de885d2eacd47896640282ef17d"
    sha256 arm64_linux:   "f2f491763f70f98bb356b9b893f9e30172ab7f0a9f9990cf7d8236d46fcd9f2c"
    sha256 x86_64_linux:  "edf110a7dcaf3d6bbd036566854e6dfc3ce9ee0a2da935fd2a2addac627d930c"
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