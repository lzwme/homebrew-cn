class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.90.6",
      revision: "28f6c2dbfc5d3f7dde8d566a9214f6e0f55a9d17"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc629f72345afffcae0a906304f0415c41190dba9bbee7baeaca7ddef432e447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46ffb8c4ad5f9d68b7f766ec91e81e96000da7ea3cb256957011324c31b96ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4daa911192da5a6755a51d22b6024c033f6d2b8658486674424a4c3b02858faa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a726deeac5ff2c8e64964d2ba856b35ba4be253b211f833b2d814e8ae23a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54655d35c06fd408b004f5856041c6fc46b5e6dacb908e263290e47fefa17c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731915b54ab54afbcf96c9b520d19b0f89e175389efb0f5dd19fbdc544eae054"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", "completion")
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end