class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.169.5.crate"
  sha256 "1cfaa5f6f562e139a6385c93df74d055ee6aeb79df839dc5e1c09b9e8945488a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ecae3260d0631c8a3891ce39e6b04c608c8fff1d0e545b4a8b8743221af5cd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e90fcbe6fadc003fd21f0b8aa6dbe33698227f9df5d840e8a18012e37a96594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1e487b2b5c02bb5b042dfd9276311d9ed4b7e1da49497cc1ca545bb84ea4f3e"
    sha256 cellar: :any,                 arm64_linux:       "d66b6d9e0cb894c26b0d330d5a66ce46fc4cd418224066eb86c953976eef2659"
    sha256 cellar: :any,                 x86_64_linux:      "0f6099ef7d4009688127ebb76e0a40cbdf0d1db05250c74d382566394eff7924"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end