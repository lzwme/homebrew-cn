class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.56.0",
      revision: "f51793b902d1a2b9faaeda588ab67af4cd37283a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce168d62368d3967f5ccf6a6fb26210a89765329ebe5b195b527d4f7147236e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2efae545e485bd27737ad0fc169576285ce5687fa9e1cdd14e3043039366f7be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8fe6687230843e9d88fd7f17be410b6d131f19f9c918e192c56950134e16787"
    sha256 cellar: :any_skip_relocation, sonoma:         "55fed2df5cf98a0c3b68d49d9afc9ea89a9a2127f093f69bb90342cba0a72258"
    sha256 cellar: :any_skip_relocation, ventura:        "79166cf9bce5543f071067d49db7275f06cbbd4be8a458c41edc858e03b63811"
    sha256 cellar: :any_skip_relocation, monterey:       "2fe9208ccefe27b23ea171be9639876542e696f3b8d17f56a014ed6b92c26b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad44263166334c3304ab456a6cdab44a3bbc1dd0860b5bbb759bdfc4ea46b208"
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