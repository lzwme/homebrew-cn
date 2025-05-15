class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.43.0.tar.gz"
  sha256 "192ddb57d021436d93ed8ad1fadaaeef20ce59a2296f31af65e12978b48feda5"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "060c07e40bd94df836c4532184f0fc32156b97e69954e3b4c885c7f9dfc5c74b"
    sha256 arm64_sonoma:  "689ae78665ff23979c0cb911df53badc43148b32d0e8727e4221aecb307de244"
    sha256 arm64_ventura: "3b7c730c8f363d816af4f2e7919b7a76305739973ab37c5d5c911da21ef1d091"
    sha256 sonoma:        "f882d4351146cb0e3f97f2706271dfd3f9a7211ba0c08acac014bf9884ce7f1f"
    sha256 ventura:       "26b0fcc6d3d157bbb460f2613c9642aa7b896210efda3d1762a55edc8615ae19"
    sha256 arm64_linux:   "233153a54b8c3590b72e69d15d8fdc346a1df11d366aa409121a6537572564f9"
    sha256 x86_64_linux:  "47fbdefcc5567b47a3f3aaa9c012486346287d3cc2aee95883d16295108de06c"
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