class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://ghfast.top/https://github.com/walles/riff/archive/refs/tags/3.4.2.tar.gz"
  sha256 "51f41141af4d7b2b60010fc165cf5ff42a79fa50a6996ba6f8771ecc8f9e525a"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5ddb1c30477617eacb5d6331ea619926cb64cd5b708a0fe9a5d383e11e0012c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c1f23146aff23c9856c5e9eb415724870299a3ea8317c2610d4eba3064eb31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7dd4ef7a0233cfbec5d89a7f9686d07c665a59065257a34d9d059da3a6dd7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf86030ebc2cb8b59a539e1ee6e38b64d9cd570946981dcc1b7e2167ea8508b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71553cc53958f5a04e9902f964ae80ecdac5661c007f440093b61e6d16417ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ade08cb5f77396cc4533301859f60d7aa50d0ab07df1623cfdb93129412a87d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end