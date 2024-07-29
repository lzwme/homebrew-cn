class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.20.0.tar.gz"
  sha256 "461f64bda6ab4a33085b1b75afd01e72a7d0556b678852b95fbea4916ceec2a8"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "b03865ea7679ca47ed00f0e1617d1e1703ecb81d393f7d237f0cdd954e16c8f6"
    sha256 arm64_ventura:  "c282c1045fb54a08b6145c1592a6787b222dc02d77459b74dac01e6e403f0ea8"
    sha256 arm64_monterey: "11beb2f04449e047fc187008069168c922d96c8e63451881251f1d9f14c6a728"
    sha256 sonoma:         "87db110645ef8cb0d3769ca64e3b1a1b5b8372b79f069497a1d6812dd04c3de0"
    sha256 ventura:        "aeddca57649e8fc4d61b46a89fd15bf6cf773a63f02cdc914fe9a14a632d8ed5"
    sha256 monterey:       "61dea7ba154270dfc465de9b0f0b80f94d9e5107beff7e9a0e3a91fb0c133278"
    sha256 x86_64_linux:   "222d6068f81ec26ebc660588127ef8473dbf027d8003813342fc1583b7b21fda"
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