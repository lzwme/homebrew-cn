class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "0febab39be41d95c3c0b28daa5826971097879a4997be27ad601937c064bd75d"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c60af29ba42fe928e9926cf9e03aebc502ca57f0b282aa7cb0fb37bfd065e577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1ac2c21c374f120ee66024d3281c80fbc429943b296970d8f716381fa051bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2db039b683b3362e01ec1cab2b7dacfb08f8f93b0a1ae98ee1de70fefaf9a68"
    sha256 cellar: :any_skip_relocation, sonoma:        "38b6bcdc26d5508c24197080a72f5e118e1dfd25546e03dc32a6385dae0ba87f"
    sha256 cellar: :any,                 arm64_linux:   "995b546e6b93659692ee3fe9e39371aab8bf4ea122ae50881d9585f6239e7f1d"
    sha256 cellar: :any,                 x86_64_linux:  "d0f721d88836ac946f2e59df9152a1236b899547f1260646a0bcce09c4c8927c"
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