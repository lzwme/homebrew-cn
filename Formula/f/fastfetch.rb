class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.53.0.tar.gz"
  sha256 "1488d9b738474e8ef8e8d78e2463722bf706e435857c849b3f480354ad62366e"
  license "MIT"
  revision 1
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "df1987861e4af9e35b200e6f0daa33abceefe7a3189efc834152bb58b5d8e214"
    sha256               arm64_sequoia: "e846570a596f9b992faeeb0f95b4e8fe094292c9b8cf19226fda867846506136"
    sha256               arm64_sonoma:  "4f139e858a73bd6c4afdf1d27b82775297d6b89b48019e4cac6c1ee9de56e3c1"
    sha256 cellar: :any, sonoma:        "37fcc5db29369f5c45ca0784b77f4044fa67d26e989d724690e47110ba3ee540"
    sha256               arm64_linux:   "4a51d568903c11a0793daad6a609c81ed47e40a09129e2e221f8ec3041d5d45e"
    sha256               x86_64_linux:  "90f71bf63fd9cb6c80e7ae324cb01b31e685ca5ca00be280dc3108835a78aa27"
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