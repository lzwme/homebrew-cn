class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.44.tar.gz"
  sha256 "3f3faa51e437b091c3c85e341cc57c85cb852079689bdd1a83658625a532a938"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2f29f7e5ae853c8d952bc3b0405b24dc44a7bf1528577e8a0649228ad0630cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b176fe33e5dd3cad6561e3d2b03a4b5d5fcda8d16e37048bb0f60cde418470d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f49a177f1f957afab4a6e96209a130973deca8efa9c85916fd23130d203bdab"
    sha256 cellar: :any,                 arm64_linux:       "f3702e9240d55ff0d58b84c66ae7fb6a2dd0bfd4c2b15a6434c02b7c94b0bfa6"
    sha256 cellar: :any,                 x86_64_linux:      "c123fb67d0cca67cafe4a03a058034ca7c69201982004dcb2e5be7f76c11ccfb"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://ghfast.top/https://raw.githubusercontent.com/BerriAI/litellm/1418c1990fcc403d7598d97832f1272f45049299/model_prices_and_context_window.json"
    version "1418c1990fcc403d7598d97832f1272f45049299"
    sha256 "7cebbf93cc81f6cf20763782eb0122020c86e1a7ea164bd53ada49d4dc14a773"

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