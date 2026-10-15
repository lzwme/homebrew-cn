class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.33.tar.gz"
  sha256 "470a098315dc6985abe00f8f6c8bd766c71e1bb4009e5b1ddad075221b7c395c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33ddb92d9e86019e0cfd03acde97e9871c64496633851a31c4e8f4acd8e6aaa1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5bc57c98a8e0c997e00110af8f9934891f3447f25006d9d280ee0bc3ecaeac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aefb473b68ef5bc041951a3ab3e5f10553ad70ba4a69c46d9b0ea101e0a0a310"
    sha256 cellar: :any,                 arm64_linux:       "c326cb22cd8c9a1cc32bbd6704e968f909a81429d17759432ea15240823b3499"
    sha256 cellar: :any,                 x86_64_linux:      "4b1faafb426f62eb1fec44097d530be8c4c813aa663c96de5f06b58d505f2aa3"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/a114356542e2e5b179fd7dc4d123c0ff42604849/model_prices_and_context_window.json"
    version "a114356542e2e5b179fd7dc4d123c0ff42604849"
    sha256 "c718a7b2f7a8d1009cb3bcf65c3c060cd453845f21dc0b96e822aa3e949c4d54"

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