class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.29.tar.gz"
  sha256 "7004d0b8986fbeb66cc777b2d50983604798d2345faf0b3ad5772a240dc1e9b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0744a080c5dd9f7f5574d0e419bbe40e759a3a971b812aaf35a83a2d2610ec7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15e153b930a21722547ac6c9ed6fc1a9b09e97fc009cfd9fb5079bbe77199ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd75e083e0969a5318dc4aa49e95c367acf7efdfffd5e6df9f689601c371612a"
    sha256 cellar: :any,                 arm64_linux:       "1ea289b86bb2b4096bc69cc1cb2a3e414de403122de85c0adea446ec11237a44"
    sha256 cellar: :any,                 x86_64_linux:      "32191e057942f602e1ed7085545fc8164c809a3ab6c71e24d84722c2f403343f"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/541e3ed5305a530ebef74d5684d3aca2632c1009/model_prices_and_context_window.json"
    version "541e3ed5305a530ebef74d5684d3aca2632c1009"
    sha256 "9142d8a7a80cfd3f32aa797286157ca9ac81addabbca40ff043051052a2d4482"

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