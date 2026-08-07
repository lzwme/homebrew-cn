class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.67.0.tar.gz"
  sha256 "d962730d14454cc24a31b796f02459274741034b4b774888b1426be0854b615e"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "aa9a4f24c853922b9de02f7a7da30beca050b729a53fcf51dca0a71e6d4b553b"
    sha256               arm64_sequoia: "dd3c5c55760d8a38b88fc9fbd3c3ec00265f69d690ced7c47b40f6ccf47e5613"
    sha256               arm64_sonoma:  "5acdb535e8e7080a1e421266a7cd146f6f42721d8ba814828c0346e44b4c5e2e"
    sha256 cellar: :any, sonoma:        "e6ba1079ebab43cbc9653ecd6dbbdf44e9b0cb6e02456e50da88408899f252b1"
    sha256               arm64_linux:   "fd6f0444423a5ba3e71754a1784066f7b91db6651ca809ae4aa997a91d0474f2"
    sha256               x86_64_linux:  "e09dbf9ccfa7f9e36960205be137cd1031ad153321d2b87ec2f3382d6980f2cd"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "lua" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

  uses_from_macos "sqlite" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1700
  end

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

  fails_with :clang do
    build 1700
    cause "Requires C23 auto type inference"
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