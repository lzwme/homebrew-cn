class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.42.tar.gz"
  sha256 "1e210b99a970370912260cdafe64c8320e70712527d6203c5ee6ee5894c0a130"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df6275e432ee726bc2912bcfe23b89e91ff45d781f9d2757ce20734b51441d4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc22b27369994f51b34872abd58ecc331198894b71db162e8e6ff1c08e2f2146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc3cb3f952e9a6f9ef5ae4d0e6371a329501760df583768bbb0a3e027f02912d"
    sha256 cellar: :any,                 arm64_linux:       "9f1a30bf30564fbf2fc5c35327a5b43768094d6d5e84e321a1c6df25a631aeaa"
    sha256 cellar: :any,                 x86_64_linux:      "a5765b5b1aa9a3aaeb5f0cded0f600db181dd076beb690e42362b1e5997ecb86"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/f2118fc7670ba3fa736d9b8f4deef9077a45a720/model_prices_and_context_window.json"
    version "f2118fc7670ba3fa736d9b8f4deef9077a45a720"
    sha256 "91da1a98e194e0d7c436aaf970800c8e734d70cc78027cfe314d5b27dfaf9a4c"

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