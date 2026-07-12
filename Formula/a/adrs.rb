class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://ghfast.top/https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a312dce020ca7290bcc5c0fe4d7f681d47a33704921e5132e4ba02fdff7808ef"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/joshrotenberg/adrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a51f20375b248ecfb1e635c3f937be84aad736f4111d29386689c6fb726db606"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23c28c6c69cec814ef54561a9559ff1393a127557891b0236cae469c1fbbd5ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "953bd645f23e0e7800f7435a2bf514800d13157e64cf869596a8813eab056c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb821cd93caae4f3b2b780eec7096329188525072ec9137c61c8a9ed5eb2f03"
    sha256 cellar: :any,                 arm64_linux:   "a3ea2da9cb09b013cd6a07c0ad33657a98b2a9068a06fda67497203b5f88a210"
    sha256 cellar: :any,                 x86_64_linux:  "64deae5195584c49faf8f6b653f926c5ea5a580d172e3a5095e877d80de2cb84"
  end

  depends_on "rust" => :build

  deny_network_access! [:postinstall, :test]

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/adrs")
    generate_completions_from_executable(bin/"adrs", "completions")
  end

  test do
    # Exercise `adrs doctor` as a CI lint gate: it exits 0 for advisory findings
    # and non-zero for structural errors. Drive a sample ADR through the
    # advisory path — ADR014 (advisory: placeholder text left in a fresh template)
    system bin/"adrs", "init", "docs/decisions"

    # init seeds a Nygard-format ADR; drop it so the demo below is MADR-only.
    (testpath/"docs/decisions/0001-record-architecture-decisions.md").unlink

    system bin/"adrs", "new", "--format", "madr", "--no-edit",
           "Use Homebrew for software installation"
    assert_match "ADR014", shell_output("#{bin}/adrs doctor")

    assert_match version.to_s, shell_output("#{bin}/adrs --version")
  end
end