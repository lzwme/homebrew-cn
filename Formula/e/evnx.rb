class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.16.tar.gz"
  sha256 "83b18e14f4fc63fbc7734b2cd50ae7be80fd9d4a9c2581084c16a2bd5367277a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed7242af6c62cb74fc7ac73312d3af863e09eb2646eb6d39be370da95b75d23b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e54e1dda4313106c534258a4aab7f5ccb847e852e5780fb31d4753248c4a301b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48112cc8cc8415ec595b518ce0c67e84679094e2100d9605ad30447c2678239f"
    sha256 cellar: :any,                 arm64_linux:       "ae8c6529449eaaa5e0265c33eb1a96c77d3dc1fda7a2093af9dd6a687af33536"
    sha256 cellar: :any,                 x86_64_linux:      "60ccef3e827f3c5662b748c8ea28adcaba8a85273f76c714362f739e0914f9f4"
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