class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.57.0.tar.gz"
  sha256 "3bad5a66d8c641b69ed2e8c630eecb5eed8a6ee283a3b4fe97051b16cbef1b54"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "0a05a44bc9902275b7eec21e525ae76a4fffea24ab5d9ed4ca63c830376a5f6e"
    sha256               arm64_sequoia: "26bddf1e1b2f6b41eb0dc74b5a21629ff5738a22c3fafae92aae52f78e11b1bd"
    sha256               arm64_sonoma:  "487a9de729e0ca67f9cd5ab39d86d52f04917dc3961d00b01e1979b496cc1e6f"
    sha256 cellar: :any, sonoma:        "b3756b170a750c0ed421459f57644181674ac5857fc2d067460a2601d94ee505"
    sha256               arm64_linux:   "651a070e91417bbb8d78f849a44b7c8ae6b68c92c8b449cb1617ff29b7ee74b2"
    sha256               x86_64_linux:  "e4941e62e0ba32bd35206f95c0e263726dd918299da1d8a5c9e3448d4d0fe1d1"
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