class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.6.0.tar.gz"
  sha256 "f9e18b6b0291679fa2c9f934bbb18a849c9c5b37d93c803a91f7e8ef40cecf6b"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "2fafb749088ea6a9f58149885edb6dd455d9058bb3391fa91ba845c4391255b1"
    sha256 arm64_ventura:  "37ceee672087e5dca651918014d718f8ea4aee1e6e931a90576240edb7f5ca2a"
    sha256 arm64_monterey: "9473b95a1a8b682e5e56ba22cc68aaaf5628ff51aa3b7d142a1afcd3505b56e6"
    sha256 sonoma:         "dfaad239fd6cd6c930dedaa55ca12f200786b215ada773bde1eb66f1078416fa"
    sha256 ventura:        "6c7f929782e4e51dfb5140605b14f1ee3223edf0c7951413951001d6c7ab1874"
    sha256 monterey:       "fa3c2c005ef8c97f55ecc7ebc6e48ccfba32350b695c06e168aef92d911dc597"
    sha256 x86_64_linux:   "1e44537dd7e0545c171daa18ab463b9169603efb096e1e6b870a1acaa7b02f7d"
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