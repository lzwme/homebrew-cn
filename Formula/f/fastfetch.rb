class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.37.0.tar.gz"
  sha256 "a5739be74686fefc731f7ce1669c645ca98172ae3ed5e7c3d48176df43aea5af"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "fbd5089df4fb0d07e6e8d0c51d024c12ca6fa13a407acc6e11c01de3e6efea36"
    sha256 arm64_sonoma:  "72f8ba37931c6ccb350326f67c30a68bd698620cc33df2cbd6de3efd9a287635"
    sha256 arm64_ventura: "f02cdf40d67058d8b8647cbdbaffd5f155b17be3fcdc865cdd85f32670b7c384"
    sha256 sonoma:        "42a2fb092e002b31b1de11593e188e12bd058eb08f2509561c39220093f374f0"
    sha256 ventura:       "eca9318fa0279c474edde9074c04c74f8dc23f549e3484d638ebdd7ea6747a5b"
    sha256 x86_64_linux:  "2c701fc6b8d16ff771cfb789cc37c22d4adb644222a0c50416997d27b4dc6a6c"
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