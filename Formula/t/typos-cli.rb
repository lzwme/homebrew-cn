class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.28.2.tar.gz"
  sha256 "563b1016791e35645bcb3cc752671f065f71774729a146e3ee66c156a2d09a55"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e68a44a07e0d67864f2b7ef2e9c3f471b966ed566af79b6e31b702f46079b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "245ec327534103d4cc48091014346bad168ea03ed1305e1173b5c73fd54f5061"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a17ce846d9acb7d5b64dd275e092648b20dbe8e782192cbd43aaaca1e6fad822"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e53d109b748ad96a0589f7ce0042339817225c4da2765fa4377d9cd6baa26f"
    sha256 cellar: :any_skip_relocation, ventura:       "87b938972305eab81de1f79de07e5d90beea280766b8004dd6befee1767951ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56fdb6f1d8a250b33429ad2879fdb4bad3fedbbfe32e2e9cea4258d839a092ab"
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