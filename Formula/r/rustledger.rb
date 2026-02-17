class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://ghfast.top/https://github.com/rustledger/rustledger/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "3312b7ecab442844849ed0d618af1e21fc596ee0dd2d024925cc365335e6ea41"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b894941d4f87de0966d23ff0ede25bb8a094c1f2bcafd8148e04f5f5585277cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bba074508e3694f1b8569e7b705b1be56eb0b50f3ebd0042975d907ae43568a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40c6144b500225a00c63fe2edfdda41cab7585db0e838f696ceef2075fa8dfa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f0030311b68e6d59a193b2eb6d04a5d64d6edb825169a1c3f8888a736233785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc6324f8016632d3d77bd3656687ca2d2ec9f67193f1a15c71ef5a880fa332e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5725f6018e48c14f2cf9016d2a7652e6152e0f448b78d5b70e2c80095e1b6c98"
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