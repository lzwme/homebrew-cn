class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.18.1.tar.gz"
  sha256 "53421de317bfc918e168751cf910e7faa51ebbd71f6f4de3b56d2cc74794365f"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "e961084a36f72d979c5e847eaecfd9158f9d4dd2359deb5e92e0f9b0d6158061"
    sha256 arm64_ventura:  "22ac070514793d42286dfdc10aa89560fb4a49ff3d26e326965d94f3fa21606c"
    sha256 arm64_monterey: "b47f30f67c727d89e2ae9803bde6c6fdf333976d91bb21afdb585a6998d5ea0e"
    sha256 sonoma:         "918f4faf971ab5181a7fa536998966f57dc990858ceec018fad4b9a4ad516d0e"
    sha256 ventura:        "448d451a370bed4648ad6c07128128a69c548b3314920d180ecacf4e9e2d1dfc"
    sha256 monterey:       "88af23024a42da2a6a6729d36a81eac765910a4e39d1170073e73f5199655dc0"
    sha256 x86_64_linux:   "886827db681746af518e2ab05cfad767e80abae64eb9529387aa5c483af970a2"
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