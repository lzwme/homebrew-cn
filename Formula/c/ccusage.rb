class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://ghfast.top/https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.23.tar.gz"
  sha256 "24c16f14ee72801ac913d751b891a8eb9dde6ef85ee5302c1e26643a745efa84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d85125f99e1fcded832b25507ecde4c9f91def8c73a9f2ad72b1e6a9e6161280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "557b98b6bdb2d49dc683b5d3644bde57f3c59216cb6321a05522b025b9d97e9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4dc971d28fa21d5e7af44952556bf0c184b1550acfca3191e570a1791dbb5159"
    sha256 cellar: :any,                 arm64_linux:       "d35c414649920e9779b4fb30eb87e05ed87a8d611dcddfefb2d81a881c66e21c"
    sha256 cellar: :any,                 x86_64_linux:      "1e698f3864277cb152344dce7d668c11f9d13aa231fe115bbb2bca2456413921"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage", features: "fetch-litellm-pricing")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end