class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.33.0.tar.gz"
  sha256 "fa3b5c3c4fc7d2b6c4e24c15fb7cf3df94024227f2d24995f6ca0eaa95f39725"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "a2babae004fd3cba1d2757911efa32c825384ed415d474db3c22f86a16aa8026"
    sha256 arm64_sonoma:  "5ab9e7be9b14100dfc93b38b97e08c84111ae903d2a108c1afb47ccbb8002425"
    sha256 arm64_ventura: "aa0216551f78e92eea226680c9d49654a05967d879d73a9a6348f27770a97ef9"
    sha256 sonoma:        "06a6491bfd63c244f10836d40db62eb8bb03251ae1f3b649d966c83de02437bf"
    sha256 ventura:       "f72439234a8a4459489556f423f8dae325b3e6e7c241155e008f71a8c19a8fb1"
    sha256 x86_64_linux:  "02a6922c9aa945e8b8f3bb504aae9b9bbf91b04a6f7245c282c429b83b262241"
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