class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.13.1.tar.gz"
  sha256 "23bdf0789a8387c958ea1ac69e7ddd514b4de8199f09e361735eab10674665ec"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "2a3cd6eae45fa25bd1e0ca5c70507d4f71f1c58725f6385ba47ea8373c5c4fdf"
    sha256 arm64_ventura:  "08e559e441055c67f289f4aa816375095acee652e35f05b6e2c8d75b61013439"
    sha256 arm64_monterey: "a08fe987960a355a5ddbb2162805ef481895ff300b688a568ab5c152bfaa96a5"
    sha256 sonoma:         "9d6e0e78c50347f973d3b64835343cd0988468ea522fdccbf49e6a12d619c49e"
    sha256 ventura:        "e0cf35372a305257f8ffb3e051b804f8c883fe5e6d83197a57332e61359976f3"
    sha256 monterey:       "47995eb8320a1a2eab5375b4f953a6cbfe2375f0ea46f2ca7582cfa5bf29ae27"
    sha256 x86_64_linux:   "c9de9353f528226e875aa477c014528baf56de6ddfe42d9047138b621ea8ce96"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
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
    bash_completion.install share"bash-completioncompletionsfastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}fastfetch --version")
    assert_match "OS", shell_output("#{bin}fastfetch --structure OS --pipe")
  end
end