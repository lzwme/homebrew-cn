class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.0.1.crate"
  sha256 "4f40d124fd8d0eb63dba2f3f71b64becd576bce6ecf4ca67e563c648d19a1e4a"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6af8f5f221c88c05ffa676a106f19528dd5881cd925a7a55e46c616431d0c59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff85302624f1c0c111dc880f7eb9a2d3babe2f7de68043ec81351f33dbfeb5c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda3a6593aa2d75bace6dc3b561c1f5668d80af5d3a80b5053d586b3c9192674"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f80da83e652c6b1edebe0a0191cca2fd7038a5992b35c1ee5905092ae90ee9"
    sha256 cellar: :any,                 arm64_linux:   "17efd1d6b55ff91187479913f4c0d2ebb86ec0ed63de4bbd7ff0db4850fc3039"
    sha256 cellar: :any,                 x86_64_linux:  "2ca369544cffa67fb25ed03648f45c240dcf58aa10fcdb81d6bb6a61464a849a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end