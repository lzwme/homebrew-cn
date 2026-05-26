class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://ghfast.top/https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.5.tar.gz"
  sha256 "e9a9cfb98d88e6aead0bfba7ca61370c62c7411fe4c538fd16915078f313a63e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629813bf8b842732b1e4a15655fef90c96ab62aaf83633e4382428ecbbbe54a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0557b790997ec593f729e63dc9524b6a582455e67d84434744c93f5f078fcac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54d47a28b5e974f4e23d6afd7e966f9b50ed7f609f29b1cb11659d62276eb013"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e0eb9f01a93ed84c60457b4b256da5db6307e242985421f099e2ea7447aff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345dd292adcfb613cd229f305a2842a35e2bd261a21c92f0095fa152d81bead3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d39018ac431e2ac72ba0ec0ddbcd58207ffadeca27cff179e9ec4b90297c29"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end