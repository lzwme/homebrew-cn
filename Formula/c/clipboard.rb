class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https:getclipboard.app"
  url "https:github.comSlackadaysClipboardarchiverefstags0.9.0.1.tar.gz"
  sha256 "187eba2a2c72d32d35ff750b947f1c812e33f9af538a6fc1b781e18a5e912d45"
  license "GPL-3.0-or-later"
  head "https:github.comSlackadaysClipboard.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1d109f92c497e248f9b525f03703105cc659bb14069302f9693c61df4c779b07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00ca5ce7fccc8f29a81b39db0150b57344a7d37da5b40c6f8f267ddbcaf92b66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08730cbffe1c790373c6f0573d895035c24fc0a256c2d65c3800e2873e0e7e91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e280365f64e4fedd36eac66de93af0073ffb20a897cc8a6474306db999f0067"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd91836fb23f4a06eed6772a3e7e34166b7834a326408356f9ce80967c10a2d1"
    sha256 cellar: :any_skip_relocation, ventura:        "bc007fe7e6742aaa547e7f78a58d0f15d5ba1805b8c6aee32b45cccd29e3de7a"
    sha256 cellar: :any_skip_relocation, monterey:       "93a7fe327bcbfa11a18d4c2319480f986ba40a534dc7ff5fd33385f66262f500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d05d5800c227a9807a3751b80adf7d881559f13907b24e3c769f1df202b9a1"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "wayland-protocols" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "wayland"
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20 support"
  end

  # dont force CMAKE_OSX_ARCHITECTURES, upstream pr ref, https:github.comSlackadaysClipboardpull202
  patch do
    url "https:github.comSlackadaysClipboardcommit41867bea719befa2f9e3e187997acfc803f919b1.patch?full_index=1"
    sha256 "97cccf3b937592749ee24f25f1fe35f85a465c2bdc2f6ad2a21c15001d609503"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    # `-Os` is slow and buggy.
    #   https:github.comHomebrewhomebrew-coreissues136551
    #   https:github.comSlackadaysClipboardissues147
    ENV.O3

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CLIPBOARD_FORCETTY"] = "1"
    ENV["CLIPBOARD_NOGUI"] = "1"
    system bin"cb", "copy", test_fixtures("test.png")
    system bin"cb", "paste"
    assert_predicate testpath"test.png", :exist?
  end
end