class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "727289d71177fa6f15939d0c735ba116784e2ff7d8db20a97290d3b1622c86e2"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba0b70b7d37931023f53e3d877fded014582e352b2697bec10fa0f3e3fd54f14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa8fcaf421a6e15768ce458f1b162af44b6a3c461369af7e257919cacb9948c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "744ba21a33e8a62b181ee36ed5a88691038234a8d79578ab68a4e727704b00ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c3259577f1e3ad18e338975bb29befcf2bd505b8e56f088c2186c1d23514a5c"
    sha256 cellar: :any_skip_relocation, ventura:       "25ce4157da81b4237ce19b1a77e722861e21af5a271cbea1ff72ebf157badfdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06930219a6c0a7d286140ca880c18673f59f5662c928a7144fbc5ea835f9a08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d99b16f6d890124beb5f908c97628c7b10f82de00a2e09ed4138f309b7de5461"
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