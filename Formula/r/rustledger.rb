class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "0bcbed0027ea28b60a03ba1762ed29db9cc7a146333031a47f8a3a09f4eeb227"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47e8c1093b044c6c3b41bcbd0dc034ab03176fe6dc5b35cd4ca00f9d2efa6540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a7260caf5c1167c83b4fefd5781638d9558e4bfc8678af36a96466f5f32811f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e49ede7ae504439808c81eb5dca60db6050dd12e53beb077fa4e1075d4337c9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c8c6d82b4e2907f1d5a679f7586a21fecd13048a231dd0d7502856a6d71e285"
    sha256 cellar: :any,                 arm64_linux:   "cd2c42f231f3ee43d0713952d8409df7118e37f36e80fbef450c55dfe594d6fb"
    sha256 cellar: :any,                 x86_64_linux:  "418c4be55c0c45772dbf59e21bfe2b0602dadb7a96d4297e175499984137b305"
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