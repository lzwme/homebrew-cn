class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.54.0.tar.gz"
  sha256 "e6a0516364bc0a4991a588537ee2abb538b86db41f7d9dff795d49baec990529"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "f1856032bf2be5bf320240d070292258ac5f38950535c6f0b884fc9c3410b164"
    sha256               arm64_sequoia: "f1fb4bbaddad085c8ae4fd8b44c43dfd4760ee4b7364f4c3327569fd7ea0d900"
    sha256               arm64_sonoma:  "90d85aba2898776f7cee3a9cfe23f68af23e3b469eae5962dd52ff7d52f129ab"
    sha256 cellar: :any, sonoma:        "2570cb7b1d9b664615c0841d6c3d53c55e50da982e60f8ac0c0691baa151acad"
    sha256               arm64_linux:   "79fd25366089ce10fede23d352b0b3aa871e5191ca0d13d8f1980b4b741f44b2"
    sha256               x86_64_linux:  "1d09a46fdfbfa3c9563d6091026a0a872eb195f40b76b7312ca840e46ccfc1f5"
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