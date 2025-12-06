class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.9.crate"
  sha256 "8907ed5489e0d707cec276e5db47029b36e218b3ffffc1e8a72062cf5229a299"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6aad1a93046fd2a4aa08bb64b1c5e5517b6b80ec007b7ba288f68c53227172de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec789545e8ab0a4c7cf281d3ce33b10bdd6a6e74d192590d73099a1aab5bc106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97241859fc15794cf0e259f6879ca0e728164491590df65d680d578360650219"
    sha256 cellar: :any_skip_relocation, sonoma:        "687c76161946777c1b04de16cad6123c892ab4b5ab47690da8340063bd7a7549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b5900e842292e1e6ce3b5d740033c77bfe8e21089624e854f85f58ab5417317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6565212a0dbf78b37e565d3d79ae552ab2d7d9f2cf391679a815fdccd1b0a59"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end