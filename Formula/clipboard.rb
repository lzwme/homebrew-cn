class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://ghproxy.com/https://github.com/Slackadays/Clipboard/archive/refs/tags/0.7.0.tar.gz"
  sha256 "56eb36ffcc0aa52e96dedcdc9c31a09871b442b118a75e2fd56a83c06bb71b66"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "980246451f5c390826547fce2d514806080ac74a7d45ec80f145e2bb66d8d01a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "087df7f6a25cfc0045f5373ab5ba65fb99024998926d4e8f304a296a8b5dafc6"
    sha256 cellar: :any_skip_relocation, ventura:        "7e64358c2bbc53a4170694c34433d10b58920469555c9e847d9313b0d09b759c"
    sha256 cellar: :any_skip_relocation, monterey:       "379934949d6927b2962e8dc801060e0a44d87702dfd55c671a2d9fae43d8c078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d487efaac4d307265d99b9fb0d2dd106d02df13ba7b12ef08242b6714c5db957"
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