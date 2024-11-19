class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.30.1.tar.gz"
  sha256 "5248311a3d8ce65f6f48756dfc0df9f8922d64f5201ee8d980497d52e924906e"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "2ba0aaadc4875972c6dec5490a45a9efc09d1374d3863aaf6ab4c4bf391ce2f3"
    sha256 arm64_sonoma:  "af31b4bec50b0a0d6f49554c73b72a61ab4b7321dbafe982de46aed989f120c9"
    sha256 arm64_ventura: "b684e4f4066e0ff71c068c40dad6bac448ce69c481f7e7b97aed356de6baab0e"
    sha256 sonoma:        "985a991fd1a9d3f5ea8e721e79a150b97d2d132cda598735e71cdc00d963adc6"
    sha256 ventura:       "7a2b918a20bff83f61d28276ff341dabea84414d7d260ae4390b0e30b3a43e37"
    sha256 x86_64_linux:  "c9c434f04308a17f5fc6ef1206ad2a5b70e3eb3b3a7a5f8c97a85f29de45ca71"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
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