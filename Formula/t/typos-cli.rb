class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.26.1.tar.gz"
  sha256 "3e14a91c7d073a9238779da43fb7a000570456a90c0bdc378e2ac34b8dd6d8ef"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a2549390c37d13d746b29d7fc13d334c9bd2469b1f22a071a8009b6d73c555b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1601097b37eefd42d03aa30c08571cee7b09c4563b1c6b3f45e56cdefadf827"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1a449c5ac31fa036195de636eddbf7a044f4e7f6a86ff51b4ecff5101a7c31f"
    sha256 cellar: :any_skip_relocation, sonoma:        "008f112b52f3b1fadf9d61a88183da2b73e6ae5d6cf450336e711d2eef4e593a"
    sha256 cellar: :any_skip_relocation, ventura:       "50467b1bbe93925c6b5aa5dfdd180bdffe943c0afa22d6f94c3e5490cb215275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5836b19e1137215c68b22b37a19618b65bf444a99c041eb1303016ad9a5a6ade"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end