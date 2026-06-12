class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "71b8a1a48b31dd39c648eef649a642f8f7b4e36f7f9a43d6619f9b8f7c0e9255"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b38db612f34202e189f6c43798a08a11c8477cd9472f94f725a11ddc63731897"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cab7120f4a6d29369c95b318fc1f638cb6a590bcbdb94e2e4a22f7ff9112c58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee703fe802f8049bb3a6f9c14425be3305ee67118063e3cec74caf39c0fbb6f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ce76df6bcec70b15afba1d7f768049d52eef9b220fec7e9a35234f5ec402d2d"
    sha256 cellar: :any,                 arm64_linux:   "9ef4d2428b22a8306f51baf780b417d1cb331b644ca892c78404ef34bdc43222"
    sha256 cellar: :any,                 x86_64_linux:  "e6465b5f634ea9f032b3d04759f7c87c3f4ea0c5b7661ffc141745084bb3e237"
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