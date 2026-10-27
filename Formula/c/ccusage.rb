class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.45.tar.gz"
  sha256 "ef6530be9b83b79b9908a0e4d1c18c8c8d1ff0c62ca88b2437d73f9c865b4b29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f753683a0e7cfcaf077368e7b7b225722c42ce6606b0a8c34319e73e2be8c1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f290651ceef5c3b1abc6a145b350a6ef3d9e320ab2e83c1ef7e37985ee9cd74b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28b3d98f5cee357914fd13d3f97b252226d924500e32adb116f070992b98cf37"
    sha256 cellar: :any,                 arm64_linux:       "c1f352b441126425f75ef9355eaf7378cd51f579bb70aab0334857be49690125"
    sha256 cellar: :any,                 x86_64_linux:      "b53302a44e65ff1b9a5934e4af3ede9d03f29dbee457a2c201e5aa7a625391f0"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/2e27a02a9fce9bdc6ece13ba3cb8222dc5b6ecfa/model_prices_and_context_window.json"
    version "2e27a02a9fce9bdc6ece13ba3cb8222dc5b6ecfa"
    sha256 "db69fee424413c7abfb45616f2db08b6a8cfdc934a264ec7ac17e333e1a9df02"

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