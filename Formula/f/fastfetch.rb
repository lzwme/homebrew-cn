class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.22.0.tar.gz"
  sha256 "ada2d56e14ce2eadaa88573dada5881684ceeaaa11df23017631b91dfa745d00"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "406949e2d44fc658ae5f0a796722d7c0c19095d841066e426c0f80f84e1d6ed4"
    sha256 arm64_ventura:  "5b8eb6963bb5c8523fb7f052c8d9d89b448401fbdd37debb2d5ddb5ab6fd7983"
    sha256 arm64_monterey: "973c68470c08963738819c5324996ce200bf63e8ea69ce51a9eceabad1c45f6f"
    sha256 sonoma:         "9dd81d60b62ec7720913acb91298fd37f449f53d9cbf15859ef2d92fcb0b7ccd"
    sha256 ventura:        "fd6690ca583613e8a14f441b71bc378c9a861d61ebf7c2c7c07c78418e3eacd6"
    sha256 monterey:       "1a06bf74aeec16a4d4559141c23ad8473f9e07ec6322589e7fcbfe511ba67803"
    sha256 x86_64_linux:   "2615c949d9c4f71b74fbd075f350bfac1fdeae1ae0f2b9a1511629e3c8824115"
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
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
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