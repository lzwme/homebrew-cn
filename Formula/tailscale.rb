class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.38.3",
      revision: "47ebe6f9560c5d20199ff7f78574fd830a60b842"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e5b4ebceacfbe33bcc87793f7e429c7156fb996a72f8ceab2b390dd5871241f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e5b4ebceacfbe33bcc87793f7e429c7156fb996a72f8ceab2b390dd5871241f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e5b4ebceacfbe33bcc87793f7e429c7156fb996a72f8ceab2b390dd5871241f"
    sha256 cellar: :any_skip_relocation, ventura:        "4e41809e88946ca1788fe5ea792d53038b24db0e24c4c992cf0e98a55ff29495"
    sha256 cellar: :any_skip_relocation, monterey:       "4e41809e88946ca1788fe5ea792d53038b24db0e24c4c992cf0e98a55ff29495"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e41809e88946ca1788fe5ea792d53038b24db0e24c4c992cf0e98a55ff29495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc06537c323919ac527e85356d7a74b2d8ea8c3e4f1004a317ca835830b6de0a"
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