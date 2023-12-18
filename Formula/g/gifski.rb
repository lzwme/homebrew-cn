class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https:gif.ski"
  url "https:github.comImageOptimgifskiarchiverefstags1.31.1.tar.gz"
  sha256 "5d06fc2eeefb4abc8ce4e2a7722178e177837c561561fc1019d1438ba85999b5"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d449584828bda7fc55259c00c707621a9fb4fdd73221ea660389ed11e802a133"
    sha256 cellar: :any,                 arm64_ventura:  "b813e553cfb3c658c6547f03d6399776661014341294c4bd6afa96bf72daf5d2"
    sha256 cellar: :any,                 arm64_monterey: "8f1028bc85484e47677a41ce3b3a25d1073acbaab7b874a1e1f2423dbc31aca1"
    sha256 cellar: :any,                 sonoma:         "32b9c8ae4418c0b42aa5fbb1c73f8793c2709d41d05c22298acb73d9beda90a2"
    sha256 cellar: :any,                 ventura:        "31171c36cf7f560a15e299a9df1ffb1c03d0ec2ecfb14eef9b195f7fb1937e1c"
    sha256 cellar: :any,                 monterey:       "0f540d5ceb3075021f5476c4f6a90c92f867c4465e194eeab3167b2b0623dd0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4cbdb9acee82d4d967ac54e81651a2f1f25a35f6fb4255ee474ab6044b2141b"
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
    system bin"gifski", "-o", "out.gif", png, png
    assert_predicate testpath"out.gif", :exist?
    refute_predicate (testpath"out.gif").size, :zero?
  end
end