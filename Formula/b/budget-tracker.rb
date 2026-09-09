class BudgetTracker < Formula
  desc "Feature rich TUI budget tracker app"
  homepage "https://github.com/Feromond/budget-tracker-tui"
  url "https://ghfast.top/https://github.com/Feromond/budget-tracker-tui/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f1a2d33109e5d9aff009921c1f43169c7d0da10cab2b360505208e5d3fe8d35f"
  license "GPL-3.0-only"
  head "https://github.com/Feromond/budget-tracker-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a73d29a2660b883c0eadb8b0e3de80f0db8c623224de96fb178a91ce91a041b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dfe9f1c0e949545ad72f8c03fb2ae3987a10ef455e9ca5260f019ebce3c8c3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d695c9d6561c51b65629edad60e3501658310326884b825c4cd4f0bb3421e245"
    sha256 cellar: :any,                 arm64_linux:   "b1c819dc382c378946d050db1dc923102b9a0dd44b88e1a2a85fb45bfcb9d823"
    sha256 cellar: :any,                 x86_64_linux:  "993b09d3a253a25fa83d6ef6858d1a414c0398252980398b48500af63c4f0d3f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # budget-tracker is an interactive TUI with no non-interactive commands
    assert_match version.to_s, shell_output("#{bin}/budget-tracker --version")
  end
end