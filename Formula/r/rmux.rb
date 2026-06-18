class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.6.1.crate"
  sha256 "0dbcc917c881d1ceed1bd93caa218b59d192a48248aafc7fd9bf87fbc541a19f"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa4fb31a7c99175960bbab35a2a4a9c1c25d74642c8bdcc5afac5138fa4cdbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96dd271c6750e2840e333c1b48b4c3e0d76b5c561032b44e8f7ca5b8e2525ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6503ac5760a6ee9489f81d73fefa77757ff20d1bd4c8b5e59d22a733dc421f4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7a0c92e345acd372495a98a0f4d2d6caeeb5b4fc4123eb4400fbc4a9b6435ab"
    sha256 cellar: :any,                 arm64_linux:   "baaefcb187b32aa9aaeccaf09b96b4123369a79ee84f27fd29127ac529c5f249"
    sha256 cellar: :any,                 x86_64_linux:  "e2917867a686a4b7db0580d9d98c05bb6ee36164431199297cf8069fd0e663f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "rmux.1"
  end

  test do
    require "json"

    assert_match "rmux #{version}", shell_output("#{bin}/rmux -V")
    diagnostics = JSON.parse(shell_output("#{bin}/rmux diagnose --json"))
    assert_equal version.to_s, diagnostics.fetch("version")
  end
end