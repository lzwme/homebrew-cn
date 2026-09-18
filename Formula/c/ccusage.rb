class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.22.tar.gz"
  sha256 "56965a96e7e512538d68ee6dc345ba816f38a5f61cddd8cf1a511e8c19e096e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9fcf58231cd3d6a6b58c52725be5424218db9bb152f1dcb5324351f487f8e18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6fe9b9a4cfa8fc8415fe3e190e6dfa6be08fc135485dbb5b1b2d21b50c0071b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "419c8ea583f38cc4f2718fe6b4445240a3fecea6fb132f5531aba0ab60d8018e"
    sha256 cellar: :any,                 arm64_linux:       "d9384d57d6fbbbb6c3c3bc2d55762249d4b49f637d8248b3c797999a133c0ba0"
    sha256 cellar: :any,                 x86_64_linux:      "ca2d2df7b2c6632442d9a35624f523ce71b259d1e0fe12b5f7d566b2d044a931"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage", features: "fetch-litellm-pricing")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end