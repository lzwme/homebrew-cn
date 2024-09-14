class Guetzli < Formula
  desc "Perceptual JPEG encoder"
  homepage "https:github.comgoogleguetzli"
  url "https:github.comgoogleguetzliarchiverefstagsv1.0.1.tar.gz"
  sha256 "e52eb417a5c0fb5a3b08a858c8d10fa797627ada5373e203c196162d6a313697"
  license "Apache-2.0"
  head "https:github.comgoogleguetzli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a9d736ee968abfde99d6ccc42c9ca5793ea9d7b1e52b7127314a1f8fcfcf32fc"
    sha256 cellar: :any,                 arm64_sonoma:   "48791444d83a6bff9ff37b33b55422cebcca2c162e0d6c8daf3bbdaf62cc5bc7"
    sha256 cellar: :any,                 arm64_ventura:  "e914138a9bf24f33e5b66a2ae0721f64551a6d0e342d2aab989417a5290da0ee"
    sha256 cellar: :any,                 arm64_monterey: "72334c25e95e54a5c5622b1e0e3f494f32117604f7d2a151a5f3dcbe15581907"
    sha256 cellar: :any,                 arm64_big_sur:  "4337b23e3a80393c75f23df48034d14e408b72647ec918caf5ae524ee6716a99"
    sha256 cellar: :any,                 sonoma:         "93a976e44bcdb34e084bc689d4cc7ab8bb8eb1b60f7f53e6b7c379599237b552"
    sha256 cellar: :any,                 ventura:        "e6a66cebdbadbf4de6e1d54e46af1e0bdb30db3b079fe73123687a4c1265e33b"
    sha256 cellar: :any,                 monterey:       "f0e8f99a914028ca43d741d20984d44f6249e3989b9f8f9a7f068dc169d8f3be"
    sha256 cellar: :any,                 big_sur:        "9f1fb787b3b21f795dd2a5d0399bf4f1263ca0e5c28f04e4d101ac33ea22503b"
    sha256 cellar: :any,                 catalina:       "14605bd3ba2aa89d0030d3935eb5ffa022712fc6eef43f969bc301beda218af6"
    sha256 cellar: :any,                 mojave:         "1599d5e292f5ca4ade99ab2627d3a0d2a3450011317dff9d5a46d779af20b01a"
    sha256 cellar: :any,                 high_sierra:    "1b3a1b5544b7a8c30553b2e8ac669d8e924d0164feb5355b0a7c2ef5807aca46"
    sha256 cellar: :any,                 sierra:         "c059346fa601885f550b50752d6d1a23eced66388b18e1c1db5169a0951dcad6"
    sha256 cellar: :any,                 el_capitan:     "a77327b3964a88a84879943171e0d10d6661cc72c5ceaa12ee2091f02930da1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f75d76355fa17bf7709842f7e1dab879c5cae613908bfd7196f6cc553238644f"
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  resource "test_image" do
    url "https:github.comgoogleguetzlireleasesdownloadv1.0bees.png"
    sha256 "2c1784bf4efb90c57f00a3ab4898ac8ec4784c60d7a0f70d2ba2c00af910520b"
  end

  def install
    system "make"
    bin.install "binReleaseguetzli"
  end

  test do
    resource("test_image").stage { system bin"guetzli", "bees.png", "bees.jpg" }
  end
end