class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.46.0.tar.gz"
  sha256 "7e4e4ab8d3e0e2ad896f97effc58df4c8d23bb88273bbdf1221bd8f0a4beb736"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "f86cb30e7b82694d40aabba7135a5665b38eff6e905f8ea4969e7d693ca3e6fb"
    sha256 arm64_sonoma:  "220277797f3d260348e68b71379cf6fc9ee6a64f582f99736eefd6c5b6aa3c3d"
    sha256 arm64_ventura: "65b5ef24209f8f45905cf143cafe01a41fbc8ef32d358d96cffb45061fae47c4"
    sha256 sonoma:        "8e97303b6849da42e1272df490072a382bc57b03bdc78ac28af4a5cbe5203afb"
    sha256 ventura:       "1ef31252faa1206a08458361b416636e9c90cbe16f262c98787ab60ac832d1fc"
    sha256 arm64_linux:   "8f25a7c8b230607b4fd0bb60d450c0b6fc903874631f59d5204632a5e9cec6cd"
    sha256 x86_64_linux:  "099271d06af8258f0c6b56f688c9f82ab791eb74a0b55d917329e72fa55ffe26"
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