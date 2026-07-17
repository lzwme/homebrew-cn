class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://ghfast.top/https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "97d9d54ac99d7c6b902e1d73b3261c19624aa024939ca96bf51e1311f9cfafa1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/joshrotenberg/adrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0cb023010ac37667b4c95af7921db251e36ce93c0ba2764fec4d60522cc66a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d297e391164afa8e634bfac3f072013722d486f4b749cb9c4f233e9ac719ea81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad60211eaa8fd9c15a56f962fba32c24372b84cac2674b4a7ee5cd76dd3f19a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8442a1270d14db8617b854b123def254358e6d041f0ba5fff6712738d8917f74"
    sha256 cellar: :any,                 arm64_linux:   "9af88443bc2bc076534f579025976e9ffc314fd85ff744ffe34a2202224e1b64"
    sha256 cellar: :any,                 x86_64_linux:  "335b43d99ac511108dcd2244dca5ab538676e2a8c430900369e3a130ef47b7fb"
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