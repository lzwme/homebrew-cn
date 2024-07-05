class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.17.2.tar.gz"
  sha256 "f41322a9d9601a5a5a74f67a3253c7e8631e6241053094d050cf02bbade8cbcd"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "a249e5a518afdecca6b65c530796af765a5b1406d70495e6e8ddc62426bfb59f"
    sha256 arm64_ventura:  "992d56213ce785235171c807b732241c0a8341c444eae39764d797fcb1e36234"
    sha256 arm64_monterey: "33c3a41786fb6613db1b9ce6e58ee61a9db1df5f49cad9fce61b782e97dad82e"
    sha256 sonoma:         "059e335b43bef2f7590e379a4be0627b40af707742b5ff439104fa55ac0f1795"
    sha256 ventura:        "495998018b9d9af90f1a7ef48989df6391d8a6d03fe14744c16a889a9d049083"
    sha256 monterey:       "0ca41f3ead2552cafb5dc33686665b85fab4e40eb6443f80402abce2fdbcb837"
    sha256 x86_64_linux:   "f918e1ed69d0b27c69e8d5248a909724e957b71abc6e1b5168cef55bbac14b4a"
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