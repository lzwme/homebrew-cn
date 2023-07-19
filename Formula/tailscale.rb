class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.44.2",
      revision: "dcac3ed784930d201ad184779442281bc524a47e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b7ed5ec3c6a06a0a91d12c25fa0fc70c6a61c04498502ff729769ec6e752d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7ed5ec3c6a06a0a91d12c25fa0fc70c6a61c04498502ff729769ec6e752d1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b7ed5ec3c6a06a0a91d12c25fa0fc70c6a61c04498502ff729769ec6e752d1f"
    sha256 cellar: :any_skip_relocation, ventura:        "7d4a70c5362daaeceddd9753f87edc5fac7291f2d1695e168d57ce671a38f743"
    sha256 cellar: :any_skip_relocation, monterey:       "7d4a70c5362daaeceddd9753f87edc5fac7291f2d1695e168d57ce671a38f743"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d4a70c5362daaeceddd9753f87edc5fac7291f2d1695e168d57ce671a38f743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "134fcb9180bccaacbcb792919250b4ae1fc8d1fcc856ec731c834b8d3cde9c24"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tailscaled"), "./cmd/tailscaled"
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