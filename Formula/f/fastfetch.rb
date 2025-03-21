class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.39.1.tar.gz"
  sha256 "ce24ba2763ebd736a1797f259da03c982b353ce0ad8641fa3626b98a17925b9e"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "949c3d5cf33727cb2daeb3c712c3329c11871be7854a1fd18812ab4577196df7"
    sha256 arm64_sonoma:  "796953dee93c086f7ad4cbadd937ea3d28eb45180383359a0052123d63c56b3d"
    sha256 arm64_ventura: "c2cdbcf05c946954d5d300960f4d642979f26d77f8661cbe6f851a82ff69dbb9"
    sha256 sonoma:        "5db7eb74cc08fa57cb6a45ac88eaefee1c45590f8bbbfc306a3d341b9b7fdb8e"
    sha256 ventura:       "250116857e905a70fcb97302e7b57039e18e25e353f1d74772101a2a2e78fad5"
    sha256 x86_64_linux:  "0eb4ccdd0c14880bb5499a483564f365e8cabe68a1061688a274d7eaaa06c1f8"
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