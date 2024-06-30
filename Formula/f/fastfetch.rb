class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.17.1.tar.gz"
  sha256 "a38969ebb757070db5dace8a42f874d8898a7232da64c73fc86c60a2c9da9be0"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "603ea0c0501576d832f9d58525cb8ea96a765ac05a0f689f4ae6a41b1e484273"
    sha256 arm64_ventura:  "d50dc7a1870381be9e2294e198efe952b67dd9ced4e289118df385979713e732"
    sha256 arm64_monterey: "94d6d5d98beab59bde565ef4c69333a8d3953c4f5e56cd8316eab6a53e266871"
    sha256 sonoma:         "f11c150df724b90701e38167cd21e7fcdb357f33394f747c5bd04f091cb1ae30"
    sha256 ventura:        "182821e486d4a756b7a010924e88dcc332d23cab574d4b8f267103cb4abc3df2"
    sha256 monterey:       "f930e7f0fc95538d16cedac12f968f61764f1366b7f2c721a0ecc38696b28632"
    sha256 x86_64_linux:   "44a88ad538f3c7b7c6c4bb4034c619fc155a560f7bcfe26cd70cbd6bcb5108d0"
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