class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "7e9ed83b0d1565fb42a42f03163739eaec6fa2e07f69030b2e44f8c4e54275ad"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdf4dec137d862f4a5ea0649a02a5f36c9a55d31ce6b40f3cce2e877c064f420"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "268b5ae2056b537814ab0a8c564e946e03fd4b1b483022bbb74455c49fd0ebd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd7553f8015563b057da841272c2743ba3955c27dec12b13c2256a4719fe2c2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b650f944e0b0009fc11981e0e16e31ec44c40141b7fa57c8fb7e4b9aeca6cce"
    sha256 cellar: :any,                 arm64_linux:   "fa3a4f5723f82b95ef267b2d9fa7624021815222b9260f1f4d8ce7a097ad05d4"
    sha256 cellar: :any,                 x86_64_linux:  "b4f9374fabc601bdbd72ae22e041b31b5051a2e374019c2430a5c8a15858cd82"
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