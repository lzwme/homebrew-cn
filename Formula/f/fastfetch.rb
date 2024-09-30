class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.26.1.tar.gz"
  sha256 "4320d1c304df6880e8c944e6a36340d12a3340477be40b2ead42be308a7fcdaf"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "1acea2d00d8e40d701b0ace90e9d9949d778a6674f88a37d241b0cf0ab546de1"
    sha256 arm64_sonoma:  "a72d1a08e8a7c41d089f4db0c43e1537a2df2db23459c02ffc7968bd9db45b3f"
    sha256 arm64_ventura: "006750af65910e5aec407beabd83519d7554a724bd80dbe63da0646bbf8f5184"
    sha256 sonoma:        "35e203d452617314c3bb67efbe3d5385a8f1331c8fce49fb03716888c96da996"
    sha256 ventura:       "4f988daffd433018522a6eb4bf55de35d2f912f344be045673947ded82d36cb6"
    sha256 x86_64_linux:  "5bf08d679943db1695061c02f1b66e87889acf194cdf29e8c77c5379f6923281"
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