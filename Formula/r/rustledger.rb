class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "c55eb9f5295451b80b4904200922e1aab1cf4814561ab23f10be10dca0056e72"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fd8db1d385e2c7cf8b83f2e56880775b2608075e8c98849fc26ee5ed5404fce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6d05204f593eb293cc4d43cf73af2e4b7e19d6ca63562c4d9d9d92fc2bfe3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a03507ade19f42d5d70689c02789997a7478b4e295b11c44efa643a5ecad694d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d8a9df59b519690f761bcbe98c82ff4ce5a7b940e93c012705d789aa1dce752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e551a73582f0d506ea4ca9910bb87131c45b002bba1fbffdfeceedee10734fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d49bc746676731e20355157e84787b2e990cd284b7d73dd4ec98f87fb069f5"
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