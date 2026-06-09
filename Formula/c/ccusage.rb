class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://ghfast.top/https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.1.0.tar.gz"
  sha256 "210f291fbb1b1ca9abe6e59a806a2981130a173b37b8fe840bc6c007fafbec78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cc8b54112f5a9eba3eb780479035f6eab1b0ef5097a4a4a246b7347d9451677"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37153a59edde9c171994b8f8f50472eb66dc2140afa9f97a44f4f024782f784"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c23f54ff7baf7a552c88101850d9b6d581ab25d17ccea99509c6f785cf84d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "304f408b2e22a553fd61d221d22ce3199f7277a6cc0d7a15993dad2315a9eb5b"
    sha256 cellar: :any,                 arm64_linux:   "d4dbd04ab65fb097e5449f727dfc96653e896e324524fe14995e4bf9c8dd8fb9"
    sha256 cellar: :any,                 x86_64_linux:  "02c91bce3e6c60aa231c4c48415a74c232808427c4f03d58a9b1d8488a1c5612"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end