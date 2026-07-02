class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "4de97fe7ba0242563a23335762be940a0fdac48ee588a63cd164c64cd2647491"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7b238a2df1b1661928dda750f6d3eb85a34f16b999afc41d2e16eb6f9240c1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368fb7612569982b49813b80b2103429140862d41574f9a6d240ec2774e1b80e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71cb62d539b3e758ec72f84f65393bbbaa502e910831b350f33fb71b67567299"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e163867ce8dbe792840ef1044eaec89d2d2327d1a4d7ff7f3fb47707c647f35"
    sha256 cellar: :any,                 arm64_linux:   "e0ebd4e563b9eee7c4b70278f8410f29239aea6e5f54f85a3b683b9f42c5613f"
    sha256 cellar: :any,                 x86_64_linux:  "c491c7013aeed3a2c47e35b3fb2da6468b50c2b5b59f9b7aa9d2911d0c87befc"
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