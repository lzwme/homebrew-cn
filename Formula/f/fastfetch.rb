class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.50.1.tar.gz"
  sha256 "947e070edcf906bfe88ccc219f65226c75c509612b127aba28e3b62ab30f50da"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "982c3daaa72ff7b01510e8806d936b80dea829a6e967646f852544cbff3a95ce"
    sha256                               arm64_sonoma:  "e744f43dbd0d97b0f23412dbd7c830e0fdafbe2b22804aa9f6c2a6f6fde5597c"
    sha256                               arm64_ventura: "d0fc72b2f2161e659b32fb9a261b6e3c1cd56d959cc56a47ed88a450be924aeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4cfe08f79f6921dba6d4fb236a3e5d4af11e8fce6bbf2b290cf496b20fc910a"
    sha256 cellar: :any_skip_relocation, ventura:       "ea7b0aa08fddcf1d48752ebf660f229afa18c6bf2826d40002f33f6fd97a2a33"
    sha256                               arm64_linux:   "4518f335a0e795415302afe3e05c498899fde685d5b4dd9a3127775261314dc4"
    sha256                               x86_64_linux:  "ae3defa586a3d4335275609101da30666556d4fa06a03ba43cc1837896ea1a7e"
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
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end