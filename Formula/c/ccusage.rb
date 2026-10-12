class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.30.tar.gz"
  sha256 "113d8abb4c24a4984d823e86c71834be8a4c1adbe643af3cf0721a65298a78c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3265b7ab13c24de4cde6028bf7d9b3d7cc2e0e8a8742c7c290659e0d0c97aee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36011386ffd7225e4c2b9e486f3f98cac8495192fd950bfcbb7eb16a2bc3c612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f67bca99c578639a9633a7571db88383fefecd436f578f7ba99b4b2b97cfa8b6"
    sha256 cellar: :any,                 arm64_linux:       "0550fe8ca4193630784ecdaaf80831e623885a4f2f59628e60ffdc4594c2064b"
    sha256 cellar: :any,                 x86_64_linux:      "cd16819986c0090d8f82da0aa1c55259ac4a615434be76429ffe3f9609cc70ad"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/a85db3c68b1c79a317e498dc8faf55e41e4c0c3b/model_prices_and_context_window.json"
    version "a85db3c68b1c79a317e498dc8faf55e41e4c0c3b"
    sha256 "10764517ded77844701b88837070f749d1b26c2573eb0ffd330b189a33d7d138"

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