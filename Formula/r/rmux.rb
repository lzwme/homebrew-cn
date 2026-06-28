class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.7.1.crate"
  sha256 "84cd80513f308ee3f6fc47f81b6239797c32750d016e9321e43222d7c2c1754d"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b85d2b51f37fbd2506252a90eb1b69aad3c34b8146b8f740b45bd077208b9f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d5cd60fa4c1f460c4ac21e2ec44bddc7894856f716d1e7cb01fe3be1dfafec2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69a5e1a187bb44e938f1dfbbaa5df1c4da50873bc6ce767a3154d6200271a0b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa461159bf7d5596efb461ad4eec4e8cc061be5db2f29ab6927808798cb98a8c"
    sha256 cellar: :any,                 arm64_linux:   "9f6b28c17b2ae07ab48384e39700e7ffb099dfa07cac26ddb54a1d6e17f0ecf3"
    sha256 cellar: :any,                 x86_64_linux:  "ccf852cba0ec64d8ec7def1de7ebc4027cd4deecef92ff7303bda13bc4f38577"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/man/rmux.1"
  end

  test do
    require "json"

    assert_match "rmux #{version}", shell_output("#{bin}/rmux -V")
    diagnostics = JSON.parse(shell_output("#{bin}/rmux diagnose --json"))
    assert_equal version.to_s, diagnostics.fetch("version")
  end
end