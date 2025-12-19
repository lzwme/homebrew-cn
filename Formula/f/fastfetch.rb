class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.56.1.tar.gz"
  sha256 "6ffd75c32b2a885fd8497867645ac837ed37d588c94e0df05408cdaa0c8fd2c7"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "9c0f4ced01e9af3268abb32f9d4c025b4654077bdbf88aa013023f359c7190d3"
    sha256               arm64_sequoia: "944a3719e88d532401e9f79e8656b081153b254d61caa08fa45ca60083e97b9c"
    sha256               arm64_sonoma:  "749342defe44a7b1bcf9bd92e7266afe8b31e99d199c454958f6439f9ecd32ff"
    sha256 cellar: :any, sonoma:        "10a9b25b87a411f61d04bb13f674e84a9b0d5d09685e2ba5deb91a9ad2933c1b"
    sha256               arm64_linux:   "126cb0b52c7a7e42caea6937e60acec1afe276ddcac67624d8342941cd11dd1d"
    sha256               x86_64_linux:  "1b2f046165211855d636c1d7f0127e4117a1a97a753082dc369efc6f6dc400f1"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

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
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DBUILD_FLASHFETCH=OFF
      -DENABLE_SYSTEM_YYJSON=ON
    ]
    if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
      # CMake already adds default Homebrew prefixes to rpath.
      args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end