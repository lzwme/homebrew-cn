class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.11.3.tar.gz"
  sha256 "7867b0cd424689dea76b0d502e07abe449939f929eb252fc21b3a27c197cb195"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "77c9a00aee69a71ad5cea87a24fd8a28cbd2041911391a0055c91f064b086208"
    sha256 arm64_ventura:  "fe37e9016bd5075109a6fe18bf028bd1ca5ba1cde96e6b704d48e229572db21d"
    sha256 arm64_monterey: "f78db6d5e720633d5fb07f4f593d249e4d4ed944781935fec9f568a938e47b11"
    sha256 sonoma:         "bbc168408134d5d7b8ede1ecc5932a0565bf6063c98b682a94fa497858ccf666"
    sha256 ventura:        "e04d4816b4e2637054c1b5ab17a4e3218c0656acca61b0e068424dcf308ba217"
    sha256 monterey:       "210f1387164d7508d139740082a42e26536ee836d54c961149194e1a0a3ad23f"
    sha256 x86_64_linux:   "1f3fd8960e573fc3c18135617a78cb3a53074bbc6ececf9553c22f74daa18d68"
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