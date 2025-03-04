class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.38.0.tar.gz"
  sha256 "f64635bfc1b42a2e845e3f3f38531a641de8203300112504b9eddc5a61f38f6a"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "3d0573d10144daaf55868ccb2e06f8a72655152fd5bceba6badc5731a73c8a02"
    sha256 arm64_sonoma:  "a4f2d1255fc99f3fc823ba22d1769c603937d92250421d33b4de6991b1de8d56"
    sha256 arm64_ventura: "ae491c4ef2991af1058eb0450c2bcc513129553b6e0630a66243772dd7f63f34"
    sha256 sonoma:        "c6790ac0b5b0520f9445e9ef95eb13e6a1db8b231c046f5a452b1bb7bd7b9654"
    sha256 ventura:       "8999879547dc53ed9cf4025bd1236679f04395b88da5dba4ad00e1b9e9aad692"
    sha256 x86_64_linux:  "dfdeb6777d0bbc8a165e23ff2456816569c177ccf39c252458afae7e476b241e"
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