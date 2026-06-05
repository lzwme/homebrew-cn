class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.64.1.tar.gz"
  sha256 "a91b736e855847aa8803efdd328c076b0048278368238ea45519bd2164f4fb63"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "69bd3353eb9e5ddb662308461cbf101032716e13cfbcb8223cbd0058b248ae5a"
    sha256               arm64_sequoia: "71e65d23960583bdf6dde4caefea0588811b26608c4218a08c8ef80f5dac3c5c"
    sha256               arm64_sonoma:  "cc20f5f8e00c0e4c7d97d1f52d8e32b112a4f758717d8f337e393c31bdaa0a9d"
    sha256 cellar: :any, sonoma:        "68bae33bf7e1fc2cb3adb8899e517948678eb5adfa836ed0b95df1fa7a698c5c"
    sha256               arm64_linux:   "248ee377dfe05c5d95ed1be85f04160dcb5148518082c78b1e206c4949ccdebb"
    sha256               x86_64_linux:  "463facbfbbdda13ae3ebde3f18e0b1b463851bbb46e078f0bb466e79814b5e41"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "lua"
  depends_on "yyjson"

  uses_from_macos "sqlite" => :build

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
    depends_on "zlib-ng-compat" => :build
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