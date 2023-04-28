class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.40.0",
      revision: "9bdaece3d7c3c83aae01e0736ba54e833f4aea51"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "324d4f2365c1d6edd870538d7b31ef9f4ea078bf4a177404b11471104ac2ee41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "324d4f2365c1d6edd870538d7b31ef9f4ea078bf4a177404b11471104ac2ee41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "324d4f2365c1d6edd870538d7b31ef9f4ea078bf4a177404b11471104ac2ee41"
    sha256 cellar: :any_skip_relocation, ventura:        "06d2500472cf6777924a23275a8f1076d7ae47eeb510bc07cf834d62a6d3e9d6"
    sha256 cellar: :any_skip_relocation, monterey:       "06d2500472cf6777924a23275a8f1076d7ae47eeb510bc07cf834d62a6d3e9d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d2500472cf6777924a23275a8f1076d7ae47eeb510bc07cf834d62a6d3e9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "967844e2a08685dedcf86b56e8fe07d1a38060a749787a75d4f9d7881678b42b"
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