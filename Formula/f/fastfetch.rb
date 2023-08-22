class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.0.1.tar.gz"
  sha256 "b42ed1d08c3caeb14610094f45492b293bb886893b85cbb7fe25e370dffdd9b9"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "5bf8d682ea2ec72210020caed030e2a70b5ba81ae6e8f191225fc4e4b6a029c7"
    sha256 arm64_monterey: "f93afbf38d573fe119b1294e21d47b907b811ae1695555341f33dea43979c2f3"
    sha256 arm64_big_sur:  "6dc865ce407d5a6e22a14d3b35d0165ebcd0bd7ed27fee905e88f1fbd1d5c262"
    sha256 ventura:        "75dc4b4b9b76b84ee79ff83034eb8592a7e158b3c80607aecfa950010030ea0c"
    sha256 monterey:       "d682691d31c9b3bea32f8610e91acf2a7210f822dcc230b8af47376d2001bf8e"
    sha256 big_sur:        "163c2a522b86a8bbce1efaaef30e4d14dc203257b06b2c72eea09982a1f77da3"
    sha256 x86_64_linux:   "75579c472271ea92f97bf6cd8297dda4e62abad6004e95115d16fa458225e7bb"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end