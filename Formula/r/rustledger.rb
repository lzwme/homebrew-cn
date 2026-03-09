class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "e17a24047ee0c8eb3680c4d873f5b812a4ffafbfcccd4cb0901bb638166de023"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f150926279469a58e4511c96c6b4de720da7d0f6b455ff45c461ea56267077a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0491144c9b937116cbd0ea2bbd67b1d1f8efc2966051b4baa5ecf3e91eaa25a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb554f55b040b3ecf1578297b269bba2b9562f46b3d190938023ad6a2793f796"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce40cf568d013086393686618fb531074629c7861ccd548091969f71162c3961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "503ad98cb6b19822554121567065ad024017dc802eedc2aee79cf5daffa70c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc963b211b7e2b3ef1d6a232eb7ce7a933083e145bd872e5197f1cbb17aefa4"
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