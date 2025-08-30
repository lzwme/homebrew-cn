class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.35.7.tar.gz"
  sha256 "b8782fa21c283f824f9c9d6f27398064d7c0cbb6bb392d2df930dfd83297b77d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ba6b8cdf0214a61f731650afcf92668e3122570010b3ad303453346241c4a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d99a2737ad7ee5584a54c218f2fc0415ccd45f8e848d2c4dae4c34d41fe81dbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05787ffb8b5b425f5bf1693f306f62e63295794f29cc7cdbbfb30c86777afcc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f50cfe5249e81aa8f7d86898f35eb965decbb3cff10250c0b5ec9b9a1107d9b"
    sha256 cellar: :any_skip_relocation, ventura:       "de2078808b0a8c828229cbb198e1c0d047f97ce96c6f2f7714ca95c8dbb517c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4ccdf9ee36e852ff54d39f4ecae25740987793a2fa4ebccf64eb30e935e5a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fb91bed0e03afaa4af54ec4e7cb2a3d2103cad294f609e3428be8c977d67199"
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