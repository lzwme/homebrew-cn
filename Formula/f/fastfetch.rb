class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.0.3.tar.gz"
  sha256 "050af39f952d44d6666e812012c9259766a5742900d87ec4e2681913e538ab50"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "907b40a6fb6c51263e66bdbe6263c692ea4e71f35b2375b1c10bddc6646be728"
    sha256 arm64_monterey: "ce9c4a7278d96a8bb1033db0742eea7951acb74ac755b238f76966cf66329406"
    sha256 arm64_big_sur:  "1248f983309de0dbf9a10c5bb7d046bd3d00bbc2fb73a9c45f2512e0bff5f1a1"
    sha256 ventura:        "6f5022fc82305e37b925538ff695da330b0a411bd5c1e338c19eb0917a27f02c"
    sha256 monterey:       "4bda8b69c271ca5ed89a29e16843dbcaeedbb39c5ee7b1a5e51f0413770fdd37"
    sha256 big_sur:        "c71c905ddd265dd8b66741877d0dfbbff7d3030027d9f4875ac6e930b3ba7203"
    sha256 x86_64_linux:   "fa53853884d1d524bec6bc13541d5d860897ed888d97e172072426b9a49f4322"
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