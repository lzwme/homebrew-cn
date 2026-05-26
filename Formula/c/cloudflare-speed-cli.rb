class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "59194ed8ab290f9e284e5b2acf7e798fedccfdd1ab64b9e7901346275547cff0"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e20a064d2ef7b152cb6d846ae28a215fd027ff85fa10ddbf19ab3e5c578df17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0afd7fa199c4b5cb73f6d84e864589649551067f1f8d1968efd4e6dd95d53ee0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afc7e75585095408623dffb7e0c5562d92f4621d09c50c30c9db1c218ea4d7cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "39134d9149bf4e0512bc199be0336c4ab22ade6ad7b60d75f208687880870018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dae142c5d411a51ff3e40e4010e9ee58820160bf09cae870dbd57032efca445d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de0a7b2cf20a6c0f9a800ccd6d20b5dff2f2fd4633c5c5b25d096ee6fb02215"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudflare-speed-cli --version")

    output = shell_output("#{bin}/cloudflare-speed-cli --json --skip-diagnostics " \
                          "--auto-save false --download-duration 1s --upload-duration 1s")
    assert_equal "https://speed.cloudflare.com", JSON.parse(output)["base_url"]
  end
end