class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.59.0.tar.gz"
  sha256 "978e2524d0dc1ff9fd8c89fb24ae5b131af18ff108da82c6d99823712557e499"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "e0a153f48041011f22f9095962194bc0c5627ec05312950e1dfcb46b8b8f0daa"
    sha256               arm64_sequoia: "b22f89b23aeec917df0c03fd7f100a36a99772d65b32d8f3eeb9c44d05d0ea0c"
    sha256               arm64_sonoma:  "f6b96cbbec06e3854acb177875cdfd26bd6c46a716398798d042c2511df92a97"
    sha256 cellar: :any, sonoma:        "738b09fd02758024961ee64d9e0a9e09ce97ab700aa8f4690371a148edca20bc"
    sha256               arm64_linux:   "27b344de5bc3dc97a97806b964367c78d6fe5386af8c978ad5189d287b4d2836"
    sha256               x86_64_linux:  "0a701de14f8e0b75dc9de1fa635bf8285a862579aac6dca80d75667b2bad22f5"
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