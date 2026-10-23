class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.41.tar.gz"
  sha256 "b09fd81819d2cb220251d58e7b5be5eaab4ea78ef51034cbe69d5670c93b158b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bdb2986cf13ec0794b2d2d4e8f8feeacd4d902b0c2959fa7385faa4e460b6e79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d16e5ce68b4fe9c4aa3d344f42182ea9cceacb3a14dc1d4b5d142c069818b436"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38ed4ddd343550dc9e441a19dc85a372982155d2759611a4e688d0fa153cb348"
    sha256 cellar: :any,                 arm64_linux:       "88c29b4f0d35b1e0d148d71859a454dda5480d105abd8beda1df4ba235a72506"
    sha256 cellar: :any,                 x86_64_linux:      "ce9a679d553659d0ac98817f3ee32d0b98011b3c89d011b65d4493a2379dc396"
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