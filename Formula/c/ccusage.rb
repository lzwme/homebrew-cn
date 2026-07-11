class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.17.tar.gz"
  sha256 "8e4d2693641dcbee649ee5c1d3c4b809d62a46f84c1e199c44995587ce45d20c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d69a0b5faef88761aace4f16965a1a719710bfd790e48bdc050deb31952455"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6699595dcd1d2ce3ad29dd6522e2631ac814625eab34de1cc562ee956e020544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f9a7e33858e8b89197508df94753445db91aad782b2d45e793a0a2f176987ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ed2a897a8fb1a901a5f1d5e5efba9744677652a9d3c47036acbf9f69e223d9"
    sha256 cellar: :any,                 arm64_linux:   "b75f9e731967bfe2098fa384b964ccc46624efbc30574265fe4ad5191ef82c40"
    sha256 cellar: :any,                 x86_64_linux:  "96b9ea90c9a57a1b661586aefb3f855367a480523c4401bfc4d9ff75294ab400"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end