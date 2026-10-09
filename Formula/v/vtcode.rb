class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.175.0.crate"
  sha256 "13ae167a4c9f01ab7a3b8b9622eb3e636ecabdc84dffb1fbdd55b87060c7ca61"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db9d35edf530aa993737913050abbaa9faaab035d3fd4f7a10d08c53b38c11c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64e6264b25b76a4e3c56c7c34c12f1363a6260b4aa0f91842ebeaa66f4f91417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67d7bdb5d798c9b31b9e5a404c6a4225f133a9641332de082d55911dca469767"
    sha256 cellar: :any,                 arm64_linux:       "c7cbf8c369b4abf60ba569b5962dc809d045837eddeec526f5f14d6e1b9c7fba"
    sha256 cellar: :any,                 x86_64_linux:      "e7fc86bce424845cd280c63b8c5e0f113975ca2ec85c209f0791f286bf4ad784"
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