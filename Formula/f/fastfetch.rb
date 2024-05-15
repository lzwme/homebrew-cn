class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.12.0.tar.gz"
  sha256 "0f6d797ae0c4dd14d09f18ee3f51f53c29d820d8fd65066280938efed414af9d"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "f3f04a28a872850c7d25b666e2d64af1057e5f87d21b30419283459c0b194503"
    sha256 arm64_ventura:  "697b315dcb1500dd2d0bbccc8b592d6a1289491dd0a56189d9c57873af5a5905"
    sha256 arm64_monterey: "04ad412a94c062d8d3da193ed7cd43a09f86bd047c041183f99e16774a04bc9e"
    sha256 sonoma:         "97d4248a9dff781d25d5e038494dcb3ecc822c321ea02abb21320a6ccb048bd0"
    sha256 ventura:        "bbe268e0d1820ffd967e81041ab24546c724129169706713fb6c696289f53ec4"
    sha256 monterey:       "2754038aa472d54c08feb741014a0000ee286d0af3fe458ec7ab2eb350eb8ae3"
    sha256 x86_64_linux:   "fd31eb1de18ddbae454f4d5c64390b4557b2a2a4d522272977bfdcad150bd0fa"
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