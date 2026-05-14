class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "c961c5731f5ea56815d7d264a61b3b84a01aecc691c4b21f25344f6f131ad10f"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39bb4d66c3eeae8dd70f08ec2b39dcc04333d066db2b338ce498f070dd83a46a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14a0a51aec30ef20de4a47780b9bf70a385c60e612907b8cd1d9eb53279a933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c44e17ce4703e6e7a04b697e9ba5a1ef22ed06f902c7cd0160cbbd0fa79e7526"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1d5baa724d449619a5b19533e2688a4285f92ddfe71df3f365babf5fb519b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac6fd7838f9e8aa472ddf5cc0e43667c67129ec4be3418b7158d4e5f14a10f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a721277490a288fd0fa6e85a62a843bb585b0102895421b57bf79113461184b4"
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