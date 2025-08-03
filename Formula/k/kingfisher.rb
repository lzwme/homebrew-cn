class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "329636a8317edd52a9478741e1515252ae365db89ee4023fa98c2bd0e506b8bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f12963a20437ef23adeaf32540612a8586f1643b32353a6dd8add60d24cebf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a112370f766f3724496ac19acbe940f22696d44e1ccab7d3ee13450c572340a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed1a36b3be7101566670f8141797a892f54149585bce10fa8471353197555405"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb0f370f0c065664478fada173f6977844661a00fcc29246a2c623fd5a201be"
    sha256 cellar: :any_skip_relocation, ventura:       "1b017aab3e24df55e3c2ef7d9dedad827de36095168667916abd135f6b4a4c87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e12792bdb37c43374d59c7e26186ad4de5babea5d54797bf8e45a91e0635adcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "397ac47125ff66f31eb76b81623ba27ae841ae1a8e5b7db315c972b42d81c43a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end