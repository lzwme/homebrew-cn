class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://ghproxy.com/https://github.com/ImageOptim/gifski/archive/refs/tags/1.13.0.tar.gz"
  sha256 "af49394306f7ececedad3237b4e36ec8f8b85095d8cb6c05f8cc1197c4cb0340"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4c07bb9554c2da9c857ddb8cbb178778215ef1a3c00849025c76d326feb4a2e"
    sha256 cellar: :any,                 arm64_ventura:  "0b22592980489848cdb2eec9eba85cf5979a7cde3ee7aed6a9d991f8861ee12e"
    sha256 cellar: :any,                 arm64_monterey: "5500f4461163a45763bd9e5421e9c1b2f0dfdbe84509f7735eb085e299e61891"
    sha256 cellar: :any,                 sonoma:         "708fc0cbe944bb4ae5244e4024deca5cb64288874b7b42c366568449110236f8"
    sha256 cellar: :any,                 ventura:        "0747136aee00a913b4b316411d0e92112447f9709be91a79c60f596abbc5d9ea"
    sha256 cellar: :any,                 monterey:       "cb238d958b5346fb809d262084f77878354f42c72680aa65063c0014379f3340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "117615056c17f84b5341097343cf5512f86da079c1dbf7072f4a039cb4f3b47c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end