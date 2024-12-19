class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.32.1.tar.gz"
  sha256 "f08efaaffa9f1c58b085105acfc41c65ed8f5721bdc7b1746b80700c727a4f60"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "94988083e11c0625cea82eee35f3c587b5f42fd6eef4ddd495f5017af476d26e"
    sha256 arm64_sonoma:  "405ad07f6494a9320f128302aee6c37867673b39494b2f3f47ecb018d424843f"
    sha256 arm64_ventura: "5021dd8a74d9e6913d67dbb93cf4d3d9ffafc515eed23263ee0bf93039532cc0"
    sha256 sonoma:        "c8d9fc3e9de479ceac2fae756de2a7e6211225639fcfc26473f30af13f0704c7"
    sha256 ventura:       "e234078ec26a64ef7dff62322675022a028a8c30c62b4b0dacafb4c2735e49fc"
    sha256 x86_64_linux:  "902da4edb8629b92e2f4366c18dcf1a88f09119e98442e693b91dce7046f5aa3"
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