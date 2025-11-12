class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://ghfast.top/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.55.0.tar.gz"
  sha256 "d99ea4f5398ef05059771aa0b1aeda4bc1d01d951ae91d93c5b6dfb550649dbe"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "893ea6859cfbefc195d7e5e7732308597ee562cdf4753e5f1ad16e0f6577492e"
    sha256               arm64_sequoia: "54a256d6b044c3b0f39ae0ecb381b6d686ea51f746a636584854684eff54b789"
    sha256               arm64_sonoma:  "3162465d36004703b88c5b578b9d52466b9fcaa4844cba7967101d3e8ec56f65"
    sha256 cellar: :any, sonoma:        "d10280764e388cdd8397f26f0a56f9dd305a59f3ae0a02a3a17bd0ca8f2ea1c2"
    sha256               arm64_linux:   "11df2217778076632a137a314de20b349ed8f6ceb6cf2c91c565c529585fc5b6"
    sha256               x86_64_linux:  "7bf0f1b8a9e099bd73cb997ba93f7c70dd09e4997063767d75d54908f9264c7b"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

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
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DBUILD_FLASHFETCH=OFF
      -DENABLE_SYSTEM_YYJSON=ON
    ]
    if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
      # CMake already adds default Homebrew prefixes to rpath.
      args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end