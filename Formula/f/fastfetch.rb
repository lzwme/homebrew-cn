class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.21.2.tar.gz"
  sha256 "680ade11a293429ae8724b6335bd27b7a165b3c3f3e8203e185a1582c8b0cd08"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "0dfc0d2d75d1d66c934edab374cd44120bbf86102bd75566a8e1e3ab7f9a52a2"
    sha256 arm64_ventura:  "6b2771fff1becda7311bba8941692b4fde77c2bb71600a2afe260adf3df78bc5"
    sha256 arm64_monterey: "3f0352e688e0ccdc3ab6ac09dd23e7442609ddc6701ec0aa32ca90ecc2b1a4b8"
    sha256 sonoma:         "69d8633f67b5c7b7490dd5ac6994f0db0f05f7e02ed8748a9e9f3f3fa7843e8a"
    sha256 ventura:        "d4359b7ef4c602d93088f6f7a496e66fcb29755a7195d8511e19cee9a1af92b8"
    sha256 monterey:       "154a3ae1721dafd289430404c743a3df3abc1b39c42310ede222095a1561303d"
    sha256 x86_64_linux:   "b43969bf296c72634854383ebcbacec342975aa5e358eb27a4049c8dcfcfea35"
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