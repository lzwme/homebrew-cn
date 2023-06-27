class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.15.6.tar.gz"
  sha256 "dda32f12150a2efae42163e69e5152b2ec14dd36daa8f35d65b9e7a4b5de16c6"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "809fc0b166748134c2a4664e7b835e2b38829c6aef4a697869d5a48e53fb5e5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b9566923325545a79b0a87acc2440d6512ee1a6bce0e44748abb863e1354a4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce67a5592e03ab23b5a28bda4f02ef114abcc0c4950c6d1cb7c4acb53d34c743"
    sha256 cellar: :any_skip_relocation, ventura:        "d4fb31135921a57557b4cbe3ddfc124ad34760dc3a51019be9fcab854435a69e"
    sha256 cellar: :any_skip_relocation, monterey:       "4e205cded423b2af215dda2120c4f70fba349ac4f397913ea13e386ef7427062"
    sha256 cellar: :any_skip_relocation, big_sur:        "b047a907bc369f68e8e9cbaebb200402c88a0c6ac759ba48bd8f7c417d45ce77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d2a289199bd6eb20a723eab4758488d52153f3945acdd29dcd386cd96094f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end