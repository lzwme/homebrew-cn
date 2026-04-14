class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "324d147ce3fcfa6abb832fdae03114a51ea6786d2ee9fdb08a13c4165ecc075a"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "379b212d2eea2c6cf1d3e60db59880319cf23bd7b7f611606fb2234867a017f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec14b5a2976d8e3cf7e7f7e856d8a6f7ba682b36cbc727f0d8b1ef44b194ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba9f6b26d84e9950dde66f0c17ac26a02b541c78517354dfda9fa3ddb6c12ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b74b86c2ca6b72d3aa7a15aed64177e33b7b1dba5ad50e3868eb8da469f39e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8786ccc14b44375d431ebd18a115cef60c712aebedefbb2425cd84f57570708a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c4f88e1a938da1d63e16db13e169d3c9982142bf4fa12588bbeda9f572a6d4d"
  end

  depends_on "rust" => :build

  def install
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-ld_classic" if OS.mac?

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
    system bin/"bean-check", testpath/"test.beancount"

    output = shell_output("#{bin}/rledger query #{testpath/"test.beancount"} \"SELECT account, sum(position)\"")
    assert_match "Assets:Bank:Checking", output
  end
end