class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.176.0.crate"
  sha256 "4bba2ac721510efac263cb822bd1ef47cd96c457e87728a0826e64390f7ef487"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e728582ab0039fa465454029b5026197f8d79a7e8098b757f01bedf131a9a71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "489b972247629c8f0250596eacb2d3fc3d44138fdfda97b6de584b531a328385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b1d31d449313b07de92488f8c4bfdb33e4ddb83c99ac4a2445535f9cd94de26"
    sha256 cellar: :any,                 arm64_linux:       "661e63584152f0d2d2c8a439c7e2a379028c004992102df0c505e352614d6ff5"
    sha256 cellar: :any,                 x86_64_linux:      "994388eddceb33050fe772a6dd494a629ea024ae07711ec4bd552e8d90bf2496"
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