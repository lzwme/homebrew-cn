class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "28d6a19aba7d4ed0933bae54b74ae99a7acd16b650deba1dbe1d694cfffe56c4"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97c817bb6dee79710a117011c5eee8b4993901168d289e7d06c62b7ec05563d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42211b3c259eabd2ee691362da9e626a089720d106cfcc7271366f415aba68aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b39abfe0ac5fb801a00a609112212f6ad190c5547f39a8eb5591056699f7dbe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b8c194f989fb0d307a62a01bd1c32a619c0acdbca87b5fcc3e3e5f5573a0a2b"
    sha256 cellar: :any,                 arm64_linux:   "c66d6e9048babea95935d4142c93340c60d5e918b39aa510b30a0efd54f0fff9"
    sha256 cellar: :any,                 x86_64_linux:  "8ea6875bc43f5d9817e4d3e0222dbd39953607092b59cf83b5d7932c8e7273b2"
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