class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.16.0.tar.gz"
  sha256 "8c5d137e0439d70189fc267176840feaba5f3e06177d57c4be9a866595651803"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "a5acc8611305b164ee41ca45571ccb114af8ce1ea09eca11d44b98d68cb4194d"
    sha256 arm64_ventura:  "245c6a3a82e356f7970e66c084ba07f41df78e2625a0e93533e111c8ef74a497"
    sha256 arm64_monterey: "8c8dd8492cb56368259f2a4b426fe0843c24f4807a9760211ed3e6b0cf70a1fa"
    sha256 sonoma:         "14dd23e3c7e45a0f25e87c2b0c3188c2375b07b44cd7087abd450852fe394ef0"
    sha256 ventura:        "de8bebb3c3b82b852dcf681ca2769b3da39df204273986628ce3199d13bb0467"
    sha256 monterey:       "97e8280e28fc6fafba7ed4ef15dfabb7dc791d7ef45d2bba0ae4d43026d1c59e"
    sha256 x86_64_linux:   "b2c97f7e5198a2d0f6f33d08275b5f820c1b98e79b4bb5918508c875dd42c682"
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