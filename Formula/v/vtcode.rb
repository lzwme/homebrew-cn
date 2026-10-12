class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.175.5.crate"
  sha256 "7d97913ee42d4236d67389df5da3b2a3988b72a62dbea1525c712b17fe43a80c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72d508cb2b8a1728849a7f0e6214c007c0e287c62b12c5d87cd4c835551d4ddf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7456fcbeeb7b8a0b146a14502c58c274c29acacc42d72e6c2bdf8c4ae185aad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c343b6d45c707344644aa4187367900539d6e6a6817d93cb11a7610780633a7a"
    sha256 cellar: :any,                 arm64_linux:       "c21793dce2a343078d41dcb24666affa943299fd23e05583911e35bf2550bddc"
    sha256 cellar: :any,                 x86_64_linux:      "81df563527757858714b51f43b2cc0f39747609d0ab9993a5c5426128545be23"
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