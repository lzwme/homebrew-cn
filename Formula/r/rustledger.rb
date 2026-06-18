class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "9ebd6288e5148414a57628daa51f0af45b2a6a4985f89a13827ae021bc2d2233"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dd6ca300a26fce7f9ebdf129c0c6845b43bdaced00d5021fb7997b8e47c8895"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a566b79618c94e2bba77c1b9db98b7504e4d00cfca2b3d2930f4f2817b336f74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd3e994932ad58f30de48b9e4dbf8a89f505f0a1494cf5c7ff69b4b685dd8f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6200a64e65623fd5360b259c8c2b7505b485f94fcfa77eb0076fe18fa0f1ee08"
    sha256 cellar: :any,                 arm64_linux:   "179e2bf08216367be8197aa6076dcd3c784139cc6a3597ac3d948d5ff3eb5b72"
    sha256 cellar: :any,                 x86_64_linux:  "41e12576b09332da963702d3585369d6b0b35358b6d5f98a83122dd41ebbda9e"
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