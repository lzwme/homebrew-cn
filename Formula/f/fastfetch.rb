class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.14.0.tar.gz"
  sha256 "f1402714b2f8a6b89d68d88937b3ad4a516e293fcc14089907ba191864b0019f"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "2fba380f3d41f6460029274e03c7274ad7c9c7cff54dec7ce57c899774b59c59"
    sha256 arm64_ventura:  "0cad6906a31713e21a712e0f87b8ec7e8f789054b0b109e5b0add43eb5062122"
    sha256 arm64_monterey: "322dbbd76bbcb2110210ba552a369ff08fd3731035ff51621cb258e0f589bb54"
    sha256 sonoma:         "ee1e30961966acd940a88a4cc8b806629b0d83054235b7095390750d9808d701"
    sha256 ventura:        "2442159c95f9ac5490ea01f1f71e8e0ea6670bef3163f304c7b3487ab8ffb5ac"
    sha256 monterey:       "35d9904081c8fab2302a9a0a99d218dfd87fc2fac8f29cc12a2af6b542a4810c"
    sha256 x86_64_linux:   "c113b30d90226377273e6bb32a27c633fbe563cbc767a63e3168fd47818f9d6c"
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