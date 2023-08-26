class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.0.4.tar.gz"
  sha256 "91d83cfa69f2eb4815c40dfe9bd931a24634f6818ecf5bfb8238a87f27ae8d3b"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "3a13b3d39ee0670b1ef5b9687a81f8470219aa66c27976742deba8881755b753"
    sha256 arm64_monterey: "4f738a8753e872295034f723676aa2e7d12812398b120c5620774513c9ca7b92"
    sha256 arm64_big_sur:  "154568da85f86551409978453eb3315f3284c90356068cb9029c3af4e9728d65"
    sha256 ventura:        "5d6a0d3daf60fec078be4c7863fb2b82ebfb2226b801a22affe60151bd40a14d"
    sha256 monterey:       "1255e82fa5301c3e02b9a5a09290174b190a063d78f79dc39ab1129085fa25ec"
    sha256 big_sur:        "bf71f816ec554b0f6bd2334a04b6cd3ce965ef4ad138910055198981f6eb2dea"
    sha256 x86_64_linux:   "3ab5eefa71f9056ff0b3f6df2c16b87ed19ea198cd6c14dfbab8fab743e2ebcb"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
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
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end