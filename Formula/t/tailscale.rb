class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.52.1",
      revision: "16c59d2294cadfcfa84e6e9d035a93e535538b42"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e42046e29b676f65dfccd689a4eb18b61dbb7dcd45ce7d60ef4ab0eff5a3875"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7066e032cf0a64d88b55f0023ec3c15b7eafaafb742ee294711d5a1c1a8655e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23195de8ccb7273bc8bc268acac01f62e24f2e9064472fce3c0d4af22f899335"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca40297d0544d58ee8bcecb59f67367dee568289563cf18fbe175eae7601b9a6"
    sha256 cellar: :any_skip_relocation, ventura:        "441bd866473b2cd9e99cf974b01d143230af4a3c4122dc4152a7eb7f5419264b"
    sha256 cellar: :any_skip_relocation, monterey:       "146f0a540b6cbd889318fd5d0499409cca9005090d6b3a6f42836c9de4243e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ae5fa08977018b736df64ee56bbc156b9b196244db8f87951a0dc6fcf229baf"
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