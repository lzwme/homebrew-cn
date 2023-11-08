class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.2.2.tar.gz"
  sha256 "bac9e3b3eed4e42eec0995cc02cd6602a4e2742bb3c6fd7a53c83e083077ebdf"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "b6c18bb832604d32a1dc3b117af245cea919cfdae8e0855f68e08241222a9de3"
    sha256 arm64_monterey: "6d6598b3068a5964a192ff04284ed1d22ad951351aa0da3c25e4f14f415f0f0b"
    sha256 ventura:        "b52d46561c71c71255dc73f8a8174004824b3457976ba5d46761f9ac68da585b"
    sha256 monterey:       "8fcfa365348439d496fea40af985e52ee58adbe1915bf4a6e7e4e07049d37d2c"
    sha256 x86_64_linux:   "0067c1d0b7ade6c0ac0e3455e18d1654a087c6ff33551d8303a10c8913304fb5"
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
    depends_on "pciutils" => :build
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