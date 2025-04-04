class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.40.1.tar.gz"
  sha256 "de1a41ee23273832d4283fca2002a9809e3f38259a0f4a497e14d5ea04b9be90"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "3e924f82323681b2dbf87bbc4eb0b6974dcbba3da2745c813def3ebc22d066c3"
    sha256 arm64_sonoma:  "e7dfac60d13aaad64d75607bceefb30b8e192b6f05551a356e79179d426b788f"
    sha256 arm64_ventura: "4b38c3487027d909b8698c76f2ba4b21eaa2129467b18e01af99c31a3da1361d"
    sha256 sonoma:        "85fde5bc2908087aa4ceafd8a7101bb9ed9f0f60912ce593fe168a3c18d54dd6"
    sha256 ventura:       "827405315c97c31bbabe6af246bb720c618b54b85209582b036cf9b208932b7d"
    sha256 arm64_linux:   "bb83b795c9200a09fff2af5e19bf0b1187a2377ff6109241ccac24744fafe149"
    sha256 x86_64_linux:  "b9ee4b4cf35514f53e4ce7b5a276f0318ccd38e61568beab544eb1e8dd616427"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DDBUILD_FLASHFETCH=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share"bash-completioncompletionsfastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}fastfetch --version")
    assert_match "OS", shell_output("#{bin}fastfetch --structure OS --pipe")
  end
end