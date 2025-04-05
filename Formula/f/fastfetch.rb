class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.40.2.tar.gz"
  sha256 "b4bc551ef2ec48cb0a14d21e266d16ea0469d55524b221464df1a7619bb339cc"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "930b662eb63dfa95fe63a5ed2b9b94ac0fff444886537db14646d5144baa040f"
    sha256 arm64_sonoma:  "36f2117391bd1a14e9a6af0ff3a4790419b1fbd6dc62a20c9a60ae9c3f5f259a"
    sha256 arm64_ventura: "757a6148d03dd6da10b6119e380590093dca0cd823c66ea77556473f960152a0"
    sha256 sonoma:        "60f7caaf6e2cc52707cbf7107bae489204ebe48b30eda1e03f3649df1f651a54"
    sha256 ventura:       "7cb8ea18c3777a09682efd8dc48652337b212161110a13bcc9f86c9c31dadfef"
    sha256 arm64_linux:   "d8fbf63611fc22c661f55cc3827abfa3d0eea778c214567ae3a5cd4f921d7612"
    sha256 x86_64_linux:  "df7d10d78a2f47881226aa03dd6c8fd56facbb3dd1aceb1fbd9e4cd20ad4c47e"
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