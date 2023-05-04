class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.2.0/dav1d-1.2.0.tar.bz2"
  sha256 "05cedc43127e00a86c68b8a49a5f68e2dc22b9baa10b1e12a5e3bc5b37876a6b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e8998e4a031c386ac63b09f157789cd7dcb0adf3aba91a2c28636d31239146cd"
    sha256 cellar: :any,                 arm64_monterey: "51ec2b4e14b1f7503ee1a136ea035815a9b1dc1f49484008889968dddbdb690a"
    sha256 cellar: :any,                 arm64_big_sur:  "cb137829cd01aab7288cd17a59b4484c7b0adb2a6203579b0230fe5b053688f9"
    sha256 cellar: :any,                 ventura:        "d8e2630dffb8db2c432265622459b7f15b20a6b9071801daf13e0376b3321157"
    sha256 cellar: :any,                 monterey:       "6ca502f364878b7fbc993c4d09637139af46f9b89aaeae7aaca92fef3e9b718e"
    sha256 cellar: :any,                 big_sur:        "c6a3d23e358758f74092f6bf4caf37fb9021dca9e790ca5ab07a412020cc8e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15566e2d62e5a449664c1505e40e0050a2ef0a70cd5cbe694df0ddc7d6ecc1e9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.1.0/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    system "meson", *std_meson_args, "build"
    system "ninja", "install", "-C", "build"
  end

  test do
    testpath.install resource("00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end