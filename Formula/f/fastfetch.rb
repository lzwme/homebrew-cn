class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.21.0.tar.gz"
  sha256 "21d085a612b6bd9ab0f4e7bffe2632e313e6f67d432251cfd5a7f877b7194733"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "8256905f261411f2e9f83f7f4c4b48d8e1dd722d919a2d231a83e8d1c47489b2"
    sha256 arm64_ventura:  "e47a798acbbee4e451afedc1a525420b28047477ad0bc509053c6aa8daeff362"
    sha256 arm64_monterey: "389344a5eb3a25d3ff0042ec160168c9acd08e3e2acaa8d20966c79ba6c27b1e"
    sha256 sonoma:         "5e75561479a8d88f1215c216bd6b99f1261382d51b89cf44d9f89d36227420d7"
    sha256 ventura:        "5a5f2df98ff8e14e3785f58acb94be617c17379b168fac58eaf896f78a1c4806"
    sha256 monterey:       "ce5cf24a04fc4d32b8f45c98a87c68a9a99ad829b70e2b9eaac108c83da42a43"
    sha256 x86_64_linux:   "eaddd202edbd2f859989f8abb506aa97d7768e5a8253aeae01169cfc9f2b9ec7"
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