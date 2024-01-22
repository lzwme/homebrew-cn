class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.6.3.tar.gz"
  sha256 "5008ccee5e111505d5ac2bafa51533f4a3521fb93b47856b8a79754754d85d5f"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "0cdb987ffeeca8f21e9a4e0e7ff9f15c141342c70a42153ede25daaefc84eb44"
    sha256 arm64_ventura:  "e73fdf84ad29cd61abb7ddd3cd878587b088fe07d602a7cfe44e371c522e3ca1"
    sha256 arm64_monterey: "9106a216c4ee1c850651535feebaca7e56540eedb25102cb83e780cb69611036"
    sha256 sonoma:         "9a2ce05a540dd341540ac5097f84c37e9eb9b0394f8fe674524578d175486dcf"
    sha256 ventura:        "602b63cf40b136aad0d02c7c440665b7ee12a334ec5782a692c1f058857f1f96"
    sha256 monterey:       "27e721e3fbb5ff8062f6235dddbe77674219842dfc3240b901fcd36d1661b7ed"
    sha256 x86_64_linux:   "1992df0c7facdea30b31b486828078b4f50fdb833fc86bf2b57a36897ecd21d1"
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