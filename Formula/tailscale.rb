class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.42.1",
      revision: "f33400c5d4812b1141bae1a69d665dc91eec4095"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ad90783e3c81b0b1f43906b22bf6eaa858d448887222a3ed788261cfe7587b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad90783e3c81b0b1f43906b22bf6eaa858d448887222a3ed788261cfe7587b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ad90783e3c81b0b1f43906b22bf6eaa858d448887222a3ed788261cfe7587b8"
    sha256 cellar: :any_skip_relocation, ventura:        "3523f3494970989d6b55a97b88af210fcedfeac7b5805920dc017fb93052aecf"
    sha256 cellar: :any_skip_relocation, monterey:       "3523f3494970989d6b55a97b88af210fcedfeac7b5805920dc017fb93052aecf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3523f3494970989d6b55a97b88af210fcedfeac7b5805920dc017fb93052aecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a603a87055acada72b15314fd5ad972fe8e99b8e8faa8b75fd55297a7919b35"
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