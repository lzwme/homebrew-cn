class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://ghproxy.com/https://github.com/Slackadays/Clipboard/archive/refs/tags/0.7.1.tar.gz"
  sha256 "ade73db60fdbdff8c68a4dc97f854aae502304e8294d57a7b32f6b01d48f8eef"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a2dd67a849867986c247cc38a83cf31ab19704d66ee8c0d59d2402c60fc0b4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63afa8aa45fb12eabc7bd8c4135cfe3531b0892ad0310709e82065550e0bb4b"
    sha256 cellar: :any_skip_relocation, ventura:        "983569e06fc435d3cac374c964c937f580bba1e81953837c0ffa88782a08a8f1"
    sha256 cellar: :any_skip_relocation, monterey:       "4b1be02e8e749428234ab78fccfbd83b259cbf303eed941898fb5478de7a5e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c9974d6e0c660e188b36d9c894df39c0aab6e28e4c613c0b662bd2262ff46ed"
  end

  depends_on "cmake" => :build
  depends_on macos: :monterey

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "wayland-protocols" => :build
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