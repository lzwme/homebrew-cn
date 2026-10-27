class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.17.1.tar.gz"
  sha256 "9febe78511568704f4cd7988afb7b7d5180fc8aedb3e3037f5c838f228308abe"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e57be4ab4f0f6654df0516eb48b1af864f43989147f98778a46b0799c130238b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d643798ce69e82f598253a82efa84530254f142365866f07caeae82f4457c653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdf55d75cad41352153d9a8919a5280c8134d007cc86f7747450a37edca2221a"
    sha256 cellar: :any,                 arm64_linux:       "645ee1d55ab15898c5187b3f7cf7770bef561c262ba4fdf8d2b51e0ace792764"
    sha256 cellar: :any,                 x86_64_linux:      "aec18df291684dea475504bebf64b1b0a7b582a6e6cd2dba95b67a636f11b8df"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = <<~MARKDOWN
      # Heading

      * one
      * two
    MARKDOWN

    output = pipe_output("#{bin}/panache format -", input)
    assert_match "- one", output
    assert_match "- two", output
  end
end