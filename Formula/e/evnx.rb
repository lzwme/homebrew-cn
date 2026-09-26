class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "1dbc6dfd260ae87b394f407f5a621545d1e3e3c06a33f7965be8c9964121a5f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81aaccc0118a046e32f410d43865776b76d7f58c9add5f3334da9a52ce20003b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4f4659e61dcab6f29e3b5a561a1d1c5e2296f47eee942acad602c6b8a48963f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa00a66dcb182b49b0a18ffbd8ece080912ec466f1ba813802add230f8d3a0fd"
    sha256 cellar: :any,                 arm64_linux:       "a7cac0816e25981f0183927d17cad4063b8edf93a051c802141985d8a24329b0"
    sha256 cellar: :any,                 x86_64_linux:      "a9749cc11e4888e8917f6c7f01b3a7140daeadfb16e24258aa317f344fe0ccec"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end