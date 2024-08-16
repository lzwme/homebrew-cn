class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.21.3.tar.gz"
  sha256 "cec1f126ade7a5ef971901b1cdbe79f5864523d7a0a92732991619485d13e2e7"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "be07e3d2a9979d6876d7e7dafd3336d1bee59fc26f2cdc92c3a9aff21782b7f7"
    sha256 arm64_ventura:  "04cf6ea48cf5b8ce750f8e3fdb86a7da9255286e9bfd8144cd901159af2cf12f"
    sha256 arm64_monterey: "187da3dd17680f41d1ae9c1d7b21fb764aae4012efe38b230b27818da06eedb9"
    sha256 sonoma:         "eafafad03f21b7100017cd46a1a7df9c9d461dba797ad7993c1960bc1edac3ee"
    sha256 ventura:        "d9610973a172925a3df0da3d4acdaa6fe0dfb4eda0411736b4ea5f3bf504d9b3"
    sha256 monterey:       "51dfb5bbeca055c49617737ee9d6d65c6aa997fa3644d4f5b9aae4f20e571eac"
    sha256 x86_64_linux:   "4927ac3162c9e38d8119c5cb4f7cd8c2518c65a5777c6e101efbce6814e22054"
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