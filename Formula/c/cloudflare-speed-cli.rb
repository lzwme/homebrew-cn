class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "01be86f39c3c817170ad508f81599ea3a59e412434533c1900cabab823e5a26b"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2248e345877b832ca150162569df3b9b5e60eac9f66dfb56b73f1e0efb66a3b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1c158f7fb0688cb23db76908104d44511bcefaee97e27b2bf7a5b890d506381"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "561f709aa99dfe1bfd87efc59721a282fd2a033908c1fc8da703255156040465"
    sha256 cellar: :any_skip_relocation, sonoma:        "223c7513d35a6d00c5c3ab5e2b2b8a38c7ab648b802cfd88858bce5d3f866c0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4becad3388c2067585704f65dd5c7749ce20d37d3305d0c232dceb7fef5fb987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887ac6a099f4f1c0e36aa9cc82b0cd9405c09064ae322d5c60a299c165890a7b"
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