class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://ghproxy.com/https://github.com/Slackadays/Clipboard/archive/refs/tags/0.8.1.tar.gz"
  sha256 "f7ceb2dbb76bc094ac8afbef97bdef0f1a9451ca7dd1a4a181f3b2a859a2f094"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb7cd95c14967d778fb8c6bf8fc41df9872df5d168302d4a9ba4009705ce81d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa8b15aa9d96a00ebc14a7d9ad158dcfa8f20f9ee1b6ebf361e13438b29da86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c49325785554c9ebb365c1a8ec2213c905a74831238f341e3494096339cd6b6e"
    sha256 cellar: :any_skip_relocation, ventura:        "6e6d598fc672e75eea970319c52aa14827f617a09ec75ae71c11fbd76fd4c127"
    sha256 cellar: :any_skip_relocation, monterey:       "6a184431252b3ed79a6b013494d31812b87fa1b0ddfac98e71f6374472dcfee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb880f65f93efd42a453bee516c21ff2125a11eef024cebf76bc6dc654ccf5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "214673f6c32a86563805184515292afa2e5c0dee3ae570591ce1885d904dbba0"
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

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    # Workaround for:
    #   https://github.com/Homebrew/homebrew-core/issues/136551
    #   https://github.com/Slackadays/Clipboard/issues/147
    ENV["HOMEBREW_OPTIMIZATION_LEVEL"] = "O2"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CLIPBOARD_FORCETTY"] = "1"
    ENV["CLIPBOARD_NOGUI"] = "1"
    system bin/"cb", "copy", test_fixtures("test.png")
    system bin/"cb", "paste"
    assert_predicate testpath/"test.png", :exist?
  end
end