class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.11.2.tar.gz"
  sha256 "de5dda91077d923780407e3c738e3afcf052025298d449d589b7b32fe4e8b9f2"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "82aa6c296012c9a5dd8b3cd290e1c94e899ef00b076586d50247d74a2fb02631"
    sha256 arm64_ventura:  "0ec64c4f8d495f86f9746cf71a91b7cf838424488ec035c8d212eb95b9ec44a2"
    sha256 arm64_monterey: "44a3f0b5e96797748c4400e0f80d08c10d94aafb9adebc847630e026bc16a799"
    sha256 sonoma:         "098c69d01487bc488bf1257f9a0130c6984fcbd4b42ec58f4a829febc09be576"
    sha256 ventura:        "36232101ec3e945a876886c1195abeca5c91ca30773b2ed494ae8befacf35dd9"
    sha256 monterey:       "bc07b60c4bb3b376e8bf683bc075ab2b5cb688e0951f808fe6b107a5a9b2cc32"
    sha256 x86_64_linux:   "fa8ccac70edf3b7da69f26b12d298bb0b382784954b67c3f0c6d3f40daf39ef8"
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