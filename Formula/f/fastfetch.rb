class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https:github.comfastfetch-clifastfetch"
  url "https:github.comfastfetch-clifastfetcharchiverefstags2.36.1.tar.gz"
  sha256 "490d5b971dd7fac4c31018354904fdd5e2c409924ba868157bda3bfe1fb5c485"
  license "MIT"
  head "https:github.comfastfetch-clifastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "cd0fa35136ca9e5abcbf8038bf0ea7e41a3fb8cb9df435f86adb87ef05d4476d"
    sha256 arm64_sonoma:  "4331e98dbff7965881fd2d48e9b59e0df42a3687c68f43cfea08fade3197469f"
    sha256 arm64_ventura: "df5a4ff4c683c7a89c65f3e3b43e8c8568a4e519d4516be079383970884fa9ec"
    sha256 sonoma:        "51dd94d5abdf752e3de424cd7f0c04561ee3bf4652ca8270f62490d9ff4a724f"
    sha256 ventura:       "46ea69d28b69401dd8aef39a074f2884d855ba8bbdedb5dc3127d2f173012864"
    sha256 x86_64_linux:  "e864b3488748767bc1abdb20af7373fac62a84fc05b91137fdda5e0e21eb1d55"
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