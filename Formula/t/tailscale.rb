class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.90.1",
      revision: "75b0c6f16430e5b1857be22f2970b5b31db8bf3a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38c35fb8ac564a51f740335b9012f1ce532fc418c261c8b8154b7323b7675992"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bfb758fae99bca701d87d8e498455e2c3de3e9a794896f91f6b2c4b3160ac9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "440343a0306eddf749e8884eadb21efea422aa31c9bd0e7592277f0fc5135416"
    sha256 cellar: :any_skip_relocation, sonoma:        "350d30887ff0d22ff08ff8be66eeb2c7790d97933f9df899554695250e89f0b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01a9588772b942d7373984143e1df662f063a77430f5d2edb6b7d167ce7864a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9c7143c4bd80380cf3e0c3b303ba11b540d0c3b06fbc6626d248b674fadab4"
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