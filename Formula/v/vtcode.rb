class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.172.0.crate"
  sha256 "a1c072ce6381ffbbf7a1ce31d276056f8331332fc47b63d9e6c7dceadee382a4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f17c8bda00396053379176696e4b8c2d169867ca4b99bd72407dfb95a2c97038"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c9c8c73da935cac414b33e4fab6931c399f9b5ecb03a86c365b7839a33e571b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2298e92ebecf1d74625e57b860793283e63b4170f5405627b6ff14aae36d776e"
    sha256 cellar: :any,                 arm64_linux:       "4e3b47e6a05ddc46d153cb35870f670810bc5aff58e5390089e67401434dd428"
    sha256 cellar: :any,                 x86_64_linux:      "cc8ae2f755dfda067cd62c794170cddaac0720419dcb11e18da6daef54d0e28a"
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