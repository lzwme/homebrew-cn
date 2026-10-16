class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.34.tar.gz"
  sha256 "d3dc5f4bcab3c73c3add3fd294b7b9d00fd99201cbc2bdabbca61587f5aad24a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37b2a4570d0690757e743b1ad4589f5155ea592f830f24e6cd517d879074be6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00b8c8bd06ab39721b269fe3512d9bc0c76636732a30722cceaeb175e880a2f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c68ced140e10c17915dd7d45fee23571b82f125df95f2f8ea086710968198eb"
    sha256 cellar: :any,                 arm64_linux:       "125a472e06c5d315c6f1a78df7f3605b02f30572f74c5506882676d473d149f1"
    sha256 cellar: :any,                 x86_64_linux:      "85c1d92b61e266ae0987f475d106997486f03224c2cf95f5e9efd1c54a33a9db"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/958cba70166f99fa1eb4f1d054adf05b64ea2f7b/model_prices_and_context_window.json"
    version "958cba70166f99fa1eb4f1d054adf05b64ea2f7b"
    sha256 "6f0153499ce0d0c1801afb97fceaede8c17d23cf548700609aba2c82956e9055"

    # Fetch the latest available resource
    livecheck do
      url "https://api.github.com/repos/BerriAI/litellm/branches/main"
      strategy :json do |json|
        json.dig("commit", "sha")
      end
    end
  end

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    resource("litellm-pricing-json").stage buildpath
    ENV["CCUSAGE_PRICING_JSON_PATH"] = buildpath/"model_prices_and_context_window.json"
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end