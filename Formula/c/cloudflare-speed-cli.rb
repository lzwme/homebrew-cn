class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.12.tar.gz"
  sha256 "1082f1ac42a27a7b46d349a6ab48eb8edb6fe7cd42f96c628e39863e5824228a"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "147da91ca2a35c017f8d2650aedaf4c45886f114bad075d38827b6784c436fad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "575181412358d78c48d2dbf9b881aaf201f7aabc36d0fc20ad639fdcbd11055c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0c27a03583df88743d4d512dadd3f43e86adf8eb182cdc851887b4f24e64cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb846ad7e13a08c10b6453c5d2c9856b058c5ded2df360f780fe6974ce85b736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b273827dd403235a811c25f7185ff56aeb31abc0b8b302dd7deff9a6c9ae2161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79c3bc9a8b0a73958246f32d6c1fdf35f62198a3afb8d85c19b83112eb9a0b3f"
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