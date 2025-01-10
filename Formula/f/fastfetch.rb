class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.34.0.tar.gz"
  sha256 "2dae260d604557c6bf5a9781b3c960aa4265a067e54a984f8c68889a578193a9"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "261f88cd110610c4cfa1ab5b28ba6bb5ed3a14317b6ccc22061d011c0f37d844"
    sha256 arm64_sonoma:  "c72bb5bccbd6766a2eedeea11719047aa4ca8e958cb1cfacbff76099a395be44"
    sha256 arm64_ventura: "2acc5f2bad1ab6cb6f094c4609df10231d4b9d114e7779c0aedece25d6ee49f7"
    sha256 sonoma:        "07674a04bdccb4cb2df4f5f37cbc32ca8e0dd2622f28d1d343539a8f9d188e5d"
    sha256 ventura:       "c90cd024215e0dadcc0f3db752570b9a46bbae8ceeca5848aa141dafe3b22d46"
    sha256 x86_64_linux:  "bd99fdadf73516bd2e3ab2f5e9ffb15f9c4ebad0db0459fa9e3623f906f05ffe"
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