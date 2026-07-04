class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "2cb82160a34e5be09b81bc1583f572bf5e1224d23a61baa11616f0a4ed9c1eb6"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73968e0d69a5e5a6200f878d9451fd65aa1a8197a7ef88abd346370dfa966d3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5786287dd9d60f6ac265d8240ad1c5b63b0c33c7a59ad7f094325506fd2d8043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "135c807149f306765950c04616b306186dedcb75b413900a2c680ad3d2ae0343"
    sha256 cellar: :any_skip_relocation, sonoma:        "9197a7e6e76108b65b0a9c2d241108ce18e7e668e686fec0bf4cd092bbbe715a"
    sha256 cellar: :any,                 arm64_linux:   "069636204ace7b3433328a178e85720ac2d358c709fd8a5694f29457a792a7bb"
    sha256 cellar: :any,                 x86_64_linux:  "596d8b960322e9a824f75a46a5b6b80fb4b2899447a1d410f6573916a13cc30e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rustledger")
    system "cargo", "install", *std_cargo_args(path: "crates/rustledger-lsp")

    generate_completions_from_executable(bin/"rledger", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rledger --version")

    (testpath/"test.beancount").write <<~BEANCOUNT
      option "operating_currency" "USD"

      2024-01-01 open Assets:Bank:Checking USD
      2024-01-01 open Expenses:Food USD
      2024-01-01 open Equity:Opening-Balances USD

      2024-01-01 * "Opening Balance"
        Assets:Bank:Checking  1000.00 USD
        Equity:Opening-Balances

      2024-01-15 * "Grocery Store" "Weekly groceries"
        Expenses:Food  50.00 USD
        Assets:Bank:Checking
    BEANCOUNT

    system bin/"rledger", "check", testpath/"test.beancount"

    output = shell_output("#{bin}/rledger query #{testpath/"test.beancount"} \"SELECT account, sum(position)\"")
    assert_match "Assets:Bank:Checking", output
  end
end