class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.82.2",
      revision: "ad8aaa0d85b90d9ebfb4e1aaa2bf94da25173b4e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288ceb1649cfea821f454c886742cbdcb33b64f8a6bda8effceee346313a6e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03eaa23c17823300242707119050d3400fb8c2d647ddcf8a6d585ae15e624d60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23a1c7c37d37c58f822e498ac25fe9ebc1d45ad45b5c7804d34fa089b56e221d"
    sha256 cellar: :any_skip_relocation, sonoma:        "53d5d06ae0080cae3b0e9e69fd857edd0f805720b84bc643065d517e7a044d2b"
    sha256 cellar: :any_skip_relocation, ventura:       "bd01c56b7d68491b47b6dcb890e06ad2c7ccfa409a6308b19bd9194bbc852271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ad360aad5353512717a4c0c8e1b4792dc0bd1ea9fd93135c08299f246e03d11"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read(".build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.comversion.longStamp=#{vars.match(VERSION_LONG="(.*)")[1]}
      -X tailscale.comversion.shortStamp=#{vars.match(VERSION_SHORT="(.*)")[1]}
      -X tailscale.comversion.gitCommitStamp=#{vars.match(VERSION_GIT_HASH="(.*)")[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin"tailscaled"), ".cmdtailscaled"

    generate_completions_from_executable(bin"tailscale", "completion")
  end

  service do
    run opt_bin"tailscaled"
    keep_alive true
    log_path var"logtailscaled.log"
    error_log_path var"logtailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}tailscale version")
    assert_match version.to_s, version_text
    assert_match(commit: [a-f0-9]{40}, version_text)

    fork do
      system bin"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}tailscale --socket=#{testpath}tailscaled.socket status", 1)
  end
end