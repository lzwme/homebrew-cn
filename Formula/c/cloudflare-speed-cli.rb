class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "bf54d0e8d89262d50b777a5bf2f545a333107e85fc9e634bba366d62194448b4"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f493cdfbf5df176c13c791e855f371c54275dfbeb9612275fcae0bbf6aaa7418"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "786bbde2e29c18d0436e8b867c39360e890165d057ed4e5467a8f2467f55b9bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c198383412f217eaa60b16dc1076b35bed9772bba68d98655efa24809e4b84dc"
    sha256 cellar: :any,                 arm64_linux:       "ff8a7319f9d0f199b662a6570df53897ba506d7705337d18512756c854121070"
    sha256 cellar: :any,                 x86_64_linux:      "d2f752cee34f386725cb9a2fec606b4a41ed43283d9547d9d15dd102d239ac2d"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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