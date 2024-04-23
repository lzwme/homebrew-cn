class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.10.1.tar.gz"
  sha256 "d8f8031775c5e39a02522c1d175752640f68b4c7b7fe51b87afaacb9c0ee5f69"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "0e768ef946f8665f43752b252a282934fc4d6b0a880a328ec81a8894eedf7874"
    sha256 arm64_ventura:  "32dba2c5054b9559a06990e5175fc435b69ebaf578f9785020aa945f8edb2344"
    sha256 arm64_monterey: "14309e09d160368d1af4f41a2d22e7f77874b7d7bf4d914a942f08860811288c"
    sha256 sonoma:         "9746e92a1af65ceb225bcf49446093f3c772a6e86b8a88805b559ec4d7c9d593"
    sha256 ventura:        "7f49ae85b3deb64f68acdefa0a2dc488db4ecb63f4847bd3102b8a6a3c5523ca"
    sha256 monterey:       "9a1b1e88c4f9420a9c19431cd7c2c63a290b8a0daa4c87337c07784eb7816f04"
    sha256 x86_64_linux:   "bcab30432246973b54099bee9230bb017ec14ebdcff13b33777b578edb469861"
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