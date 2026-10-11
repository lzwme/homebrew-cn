class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "e15a8b7654f77bbe982335c2c127219d58af45d0ceb9b17612b858444c349e64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c88808978f032300d27b363c046dcfbd776822c1d54a2be0b209afcff08c17e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56a9c0fe9dfb904ff46964a91f4b09fc78932beaee199455ebb803f349a190c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81307cc62480c00bb537a7ab799e6431870c37f718bace773438bef360bc945f"
    sha256 cellar: :any,                 arm64_linux:       "435c229964d7acdc52027a76a89dea698f99bc0fc5360fc21d85ff146d96a129"
    sha256 cellar: :any,                 x86_64_linux:      "894b6e9216c90d2c8c78b01d1ce944bd75829b28e89b58e78b7557d2acc6f2c9"
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