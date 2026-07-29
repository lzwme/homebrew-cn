class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.19.tar.gz"
  sha256 "581d3e1d061b21b85ec3ca70eefb777b79b09af526ce1ac83b51a217042ebe5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adf9f9c917e7c17d2390d75f0b170e3de1a2be78ce63f794b8eb3fb495eff032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c0359794a105ee2411eb71a8b82faf153add5f62367288fda8e7e22766eec62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eb021cfe064bd69ec96a4b80ec04027029e23bc7373762ef17a6aca0fb551dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d77e8f17e5909cd3147dd9bff9b39c3ca2b24e0bdac44620f624456df9ea509"
    sha256 cellar: :any,                 arm64_linux:   "769bb07c8891a2c939d11a4965cf54939701c6b2a0234a8040e65a24940c4d3f"
    sha256 cellar: :any,                 x86_64_linux:  "97f78c8bf9842fc0c7c46a4cd50b9f9ebdf1d9d7daa15615e130472dcc546c08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage", features: "fetch-litellm-pricing")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end