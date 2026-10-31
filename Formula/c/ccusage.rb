class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.46.tar.gz"
  sha256 "06277577201ef6e90e82bcd209942cc2ba1bdcf67190c092460acd9564905eab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b42dcd8e978ad13bb24bc2f2185b648d61ee6dde6466ec407f5d7e2b1a22190"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f393010b4a60e47f2531b34db08149ad39d82b8c140fd2dd48c0e2acd0264a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dc9ab8e6da73816f24194fd38baf36846f0510451c34e8cbbc0cc8d886be3da"
    sha256 cellar: :any,                 arm64_linux:       "48a8f31b3bf2909efd26574b3f71349237bc1dfb612dedfec56e4566757c5e08"
    sha256 cellar: :any,                 x86_64_linux:      "a0680b0f392eb3ed5c63a5841ad2b9b6fbcb74b17b2d8d7ed7a7ce9b83dc9881"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/e7f481f9f481f778aafc630d08f51e2488d4399f/model_prices_and_context_window.json"
    version "e7f481f9f481f778aafc630d08f51e2488d4399f"
    sha256 "7a3608ef70147c8d097e019a554dc5d93a0cf53779bcf14abe4fa52de2e265c7"

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