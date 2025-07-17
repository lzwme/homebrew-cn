class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.48.0.tar.gz"
  sha256 "2d7107f59518c847bca4a44007a189a64902b71a8e517eb121d4653a1bcfc172"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "66e0b30012ac0465864b7320b0d48c12412694b855216d1be5c618d6d072446d"
    sha256 arm64_sonoma:  "623cab738ce67f1c27524d26eb383d5c4ff9a389fd047b93c70f504c71e82aaa"
    sha256 arm64_ventura: "0bbf45ac6cd55b40bc4d3b3bae8d9c4a7033d6dcb2c0c3037c84dbe861158ca0"
    sha256 sonoma:        "1bfb8f536932ba2b5be3997bc721acf8351458091e542b87d388ce706b23f13e"
    sha256 ventura:       "2d6d63ee1fe5f811fc9463bc5e5d78d7f8fe564e3177051bb3cd6ec6db8e036a"
    sha256 arm64_linux:   "dc62adc71c3a059e309467486f09d34ab61699144491e97bd5cbccbbf3210cc4"
    sha256 x86_64_linux:  "437ac7b6873a62c63717328269eac78b3e02c786d74577e01db28950bf98751d"
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
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end