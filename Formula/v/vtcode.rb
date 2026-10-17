class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.179.0.crate"
  sha256 "3fa6989864852eb4da7545f87088815c6a2a51eff2c22a6b7be48be916c26ec7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1e308912006ba60c09c1a971f0a0eaacf3a09ac416156d8c12f43636ba34b7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e73a55be2451600ba2781cc1e2585b9b3c1bb409f5be3dd5700c3537fd36ad34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c2557764cac039ead6c0bef3f5a5c825fc4802b4abcbe0628006079c3324991"
    sha256 cellar: :any,                 arm64_linux:       "ccb39a6aa33fbf0f770bf7ddbcc5ac6c57ed67da9379d5bbcd25a89190c6fa75"
    sha256 cellar: :any,                 x86_64_linux:      "b4e377b2acab2a75ad0062b447ad2770b5dfaa35f6f952bc701fe549b56a1fb3"
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