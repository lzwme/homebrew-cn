class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "2e82ec46040a6cf79bf49949973e54d06504f9a20862d13500fef99090aa107c"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7746b53fa0841d430b18827556aece5889ff88a5b995cd52c21541141a18d015"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bf9f792c9d825d4578fbf41fbf88b8e81d371be156fd4480afed52056c13e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f9d9c8cac7e67e86058bb82752078b7797d73d7fee92fcba9e01aedff7e591"
    sha256 cellar: :any_skip_relocation, sonoma:        "e44e62e4d554059537aeeb9973bb80e446e5aa61e3697fc8977c5ca651c99de8"
    sha256 cellar: :any,                 arm64_linux:   "cdb3149de04b064eeb5a66683fb45edd414a4387487364d2942edd8cfede961f"
    sha256 cellar: :any,                 x86_64_linux:  "c1d8e1065ca14713d6cba103c175309f937cc2cfa9eef28a4339d63701493ef6"
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