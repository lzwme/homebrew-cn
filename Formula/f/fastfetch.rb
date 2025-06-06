class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.45.0.tar.gz"
  sha256 "f336ab5fb651fc34759117d9ef081e8c9175cb1538900a8c7b4efdf94a1de85c"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "8c0e4fd7bde6211993faf5e0c1bab0e88201c94b5661fb4d8fc4c5e9d28f07b8"
    sha256 arm64_sonoma:  "9654ef45aabff70ac9e387b3a388240740213d320db9e3ba4bd3e37aaad1f9a6"
    sha256 arm64_ventura: "ee36cb454f0dfc3cddd35a49d43a7493851fc02eecf304390e9f8c380f9e8042"
    sha256 sonoma:        "85257dbe3ffc636de71c042d742473037fc9953b9884eb944693829d2c3169e6"
    sha256 ventura:       "f2dac7e8635bac359dc5bb7fb1598e9bef7f04856024b57c2f39607f55459a64"
    sha256 arm64_linux:   "641e31b66baac37fbaac4c532c16f708d1be793bd7ddf9634d2db42ea1b89998"
    sha256 x86_64_linux:  "9ad91810578b5cb7cc39be3436beadcf3a390d243969859a856579efe85b8ac0"
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