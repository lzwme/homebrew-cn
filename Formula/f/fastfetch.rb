class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.54.0.tar.gz"
  sha256 "e6a0516364bc0a4991a588537ee2abb538b86db41f7d9dff795d49baec990529"
  license "MIT"
  revision 1
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "8cbc1adb83205a0031781834431fc899f29a31f0e18ccbe42749db59bc465576"
    sha256                               arm64_sequoia: "2379ae1e1252976d930cbadb5e56df752b32b09aee4465c09844a6dfd28180d7"
    sha256                               arm64_sonoma:  "dcba4bdd43d4f4f7d798548564dbfcb9c6a40abb08b03c9782f69ecdefcab71e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e475e59be954441c96ef923d0dfadaaaa29ecc20c19bf12a8c1b9eacb26ed0f2"
    sha256                               arm64_linux:   "529decf8ba94bbb00a5249be392de151a41fa0b4a0c1b65f2015b5a6c8ab8535"
    sha256                               x86_64_linux:  "ccdebf42c55db395916b667f6c7f0f3a1ac543db9ac786ad425cab7409078e8a"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
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
      -DENABLE_SYSTEM_YYJSON=OFF
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