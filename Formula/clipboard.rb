class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://ghproxy.com/https://github.com/Slackadays/Clipboard/archive/refs/tags/0.8.1.tar.gz"
  sha256 "f7ceb2dbb76bc094ac8afbef97bdef0f1a9451ca7dd1a4a181f3b2a859a2f094"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "905b56d8cb61547a48b81c6d20c4c6bf86c87a4b9cbaecbb9b921cad64824045"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59c1528a5bca57fd3193687e2afd434ea72200f2548e49714456893f9db29637"
    sha256 cellar: :any_skip_relocation, ventura:        "4cedf3b788c9152db3090b085358358de4ca83694a992e74df9831ae698b5ab1"
    sha256 cellar: :any_skip_relocation, monterey:       "accf49f04c232386d8c07287e0cc6c91c2676ea3ac50d04c57d25fa558f6ea6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089ef1b75f66379f325a6177cb5228752f449c85d5b22cc297a08c5e843ccc26"
  end

  depends_on "cmake" => :build
  depends_on macos: :monterey

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