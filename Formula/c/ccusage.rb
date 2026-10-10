class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.28.tar.gz"
  sha256 "c3f388f9e93c84a21c13204dff0727a9d18fba3ad9c06a703764181611732cc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fcf8b9b2a4d25225e4d0ad4c2cd80915f44252eb28e03325a324052db3de7f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a89428bc515a0e459de1deafa676f37bff3c2e6f463ae5bc5abd90cc536ed891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed3bd10109cc17759e8e294e9f3ec044179402b751e255e02ff947164f283371"
    sha256 cellar: :any,                 arm64_linux:       "0801685df8a95a4de722abe85ad8a4e0719d0326e079059a804025bca5978cb9"
    sha256 cellar: :any,                 x86_64_linux:      "33bfaf194b86939a5dc3bc32b2d8aaeae57ebce5d543260ddc9244d324de4ba0"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/d6db8e8744e36e970989aad2bb66b1b518355175/model_prices_and_context_window.json"
    version "d6db8e8744e36e970989aad2bb66b1b518355175"
    sha256 "83c752b8e9016a6200d4dc7bd857e9815f4213204f315ae44f06b40823ab849d"

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